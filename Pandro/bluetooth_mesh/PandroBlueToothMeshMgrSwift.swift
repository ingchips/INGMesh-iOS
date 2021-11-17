//
//  PandroBlueToothMeshMgrSwift.swift
//  Pandro
//
//  Created by chun on 2019/3/28.
//  Copyright © 2019年 chun. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth
import nRFMeshProvision
import os.log
typealias DiscoveredPeripheral = (
    device: UnprovisionedDevice,
    peripheral: CBPeripheral,
    rssi: Int
)

class PandroBlueToothMeshMgrSwift: NSObject
{
    static let attentionTimer: UInt8 = 5
    public var proxy_connect = 0;
    
    public var meshNetworkManager: MeshNetworkManager!
    public var connection: NetworkConnection!
    public var centralManager: CBCentralManager!
    public var discoveredPeripherals: [DiscoveredPeripheral] = []
    public var bearer: ProvisioningBearer!
    
    
    private var publicKey: PublicKey?
    private var authenticationMethod: AuthenticationMethod?
    
    private var newKey: Data! = Data.random128BitKey()


    
    var unprovisionedDevice: UnprovisionedDevice!
    
    private var provisioningManager: ProvisioningManager!
    
    var node: Node!
    var element: Element!
    var model: Model!
    var modelCTL: Model!
    var modelHSL: Model!
    var modelNumber: Model!


    private var keys: [ApplicationKey]!
    private var keysCTL: [ApplicationKey]!
    private var keysHSL: [ApplicationKey]!
    private var keysNumber: [ApplicationKey]!

    
    var group: Group?
    private var address: MeshAddress?
    private var name: String?
    var data:Data!
    var nodeReset: Node!

    




    private var messageHandle: MessageHandle?
    
    var proxies: [GattBearer] = []



    var connectingArray = [NSNumber]();
    var connectingArrayIndex = 0;
    var indexSelect = 0;

    private var alert: UIAlertController?

    weak var dataDelegate: BearerDataDelegate?


    public override init() {
        
        super.init();
        
        self.data = "abcdabcdabcdabcd".data(using: .utf8)!

//        print(Data.random128BitKey())
    // Create the main MeshNetworkManager instance and customize
           // configuration values.
           meshNetworkManager = MeshNetworkManager()
           meshNetworkManager.acknowledgmentTimerInterval = 0.150
           meshNetworkManager.transmissionTimerInteral = 0.600
           meshNetworkManager.incompleteMessageTimeout = 10.0
           meshNetworkManager.retransmissionLimit = 2
           meshNetworkManager.acknowledgmentMessageInterval = 4.2
           // As the interval has been increased, the timeout can be adjusted.
           // The acknowledged message will be repeated after 4.2 seconds,
           // 12.6 seconds (4.2 + 4.2 * 2), and 29.4 seconds (4.2 + 4.2 * 2 + 4.2 * 4).
           // Then, leave 10 seconds for until the incomplete message times out.
           meshNetworkManager.acknowledgmentMessageTimeout = 40.0
           meshNetworkManager.logger = self
           meshNetworkManager.delegate = self

           
           // Try loading the saved configuration.
           var loaded = false
           do {
               loaded = try meshNetworkManager.load()
           } catch {
               print(error)
               // ignore
           }
           
           // If load failed, create a new MeshNetwork.
           if !loaded {
               createNewMeshNetwork()
           } else {
               meshNetworkDidChange()
           }
       
    }
   /// This method creates a new mesh network with a default name and a
      /// single Provisioner. When done, if calls `meshNetworkDidChange()`.
      func createNewMeshNetwork() {
          // TODO: Implement creator
          let provisioner = Provisioner(name: UIDevice.current.name,
                                        allocatedUnicastRange: [AddressRange(0x0001...0x199A)],
                                        allocatedGroupRange:   [AddressRange(0xC000...0xCC9A)],
                                        allocatedSceneRange:   [SceneRange(0x0001...0x3333)])
          _ = meshNetworkManager.createNewMeshNetwork(withName: "nRF Mesh Network", by: provisioner)
          _ = meshNetworkManager.save()
          
          meshNetworkDidChange()
      }
      
      /// Sets up the local Elements and reinitializes the `NetworkConnection`
      /// so that it starts scanning for devices advertising the new Network ID.
      func meshNetworkDidChange() {
          connection?.close()
          
          let meshNetwork = meshNetworkManager.meshNetwork!
          
          // Set up local Elements on the phone.
          let element0 = Element(name: "Primary Element", location: .first, models: [
              // 4 generic models defined by Bluetooth SIG:
              Model(sigModelId: 0x1000, delegate: GenericOnOffServerDelegate()),
              Model(sigModelId: 0x1002, delegate: GenericLevelServerDelegate()),
              Model(sigModelId: 0x1001, delegate: GenericOnOffClientDelegate()),
              Model(sigModelId: 0x1003, delegate: GenericLevelClientDelegate()),
              // A simple vendor model:
//              Model(vendorModelId: 0x0001, companyId: 0x0059, delegate: SimpleOnOffClientDelegate())
          ])
          let element1 = Element(name: "Secondary Element", location: .second, models: [
              Model(sigModelId: 0x1000, delegate: GenericOnOffServerDelegate()),
              Model(sigModelId: 0x1002, delegate: GenericLevelServerDelegate()),
              Model(sigModelId: 0x1001, delegate: GenericOnOffClientDelegate()),
              Model(sigModelId: 0x1003, delegate: GenericLevelClientDelegate())
          ])
          meshNetworkManager.localElements = [element0, element1]
          
          connection = NetworkConnection(to: meshNetwork)
          connection!.dataDelegate = meshNetworkManager
          connection!.logger = self
          meshNetworkManager.transmitter = connection
          connection!.open()
      }

    public func initBlueTooth()
    {
    
    }
    
    func switchToScanUnProvision()
    {
   
        self.stopScan();
        self.startScan();
    }
    
    @objc public func startScan()
    {
        if connection.centralManager.state == .poweredOn {
            startScanning()
        }
   
    }
    @objc public func restartScan()
    {
        
        self.startScan();
    }
    
    @objc public func stopScan()
    {
        discoveredPeripherals .removeAll()
        stopScanning()
        connection.centralManager.stopScan();
    }
    
    @objc public func connectMeshNodeArray(indexArray:[NSNumber])
    {
        self.connectingArrayIndex = 0;
        self.connectingArray = indexArray;

        self .connectMeshNode(index: indexArray[self.connectingArrayIndex].intValue);
    }
//    连接设备
    @objc public func connectMeshNode(index:Int)
    {
       self.indexSelect = index
       let bearer = PBGattBearer(target: discoveredPeripherals[index].peripheral)
       bearer.logger = meshNetworkManager.logger
       bearer.delegate = self
        
        alert = UIAlertController(title: "Status", message: "Connecting...", preferredStyle: .alert)
               alert!.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
                   action.isEnabled = false
                   self.alert!.title   = "Aborting"
                   self.alert!.message = "Cancelling connection..."
                   bearer.close()
               })
        stopScanning()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.connection!.close()
            bearer.open()
        }

    }
 //added by dengyiyun to connect to the provisoned node
    @objc public func connectProxyNode(index:Int)
    {
       self.indexSelect = index
       let bearer = GattBearer(target: discoveredPeripherals[index].peripheral)
       bearer.logger = meshNetworkManager.logger
        bearer.delegate = connection
        bearer.dataDelegate = connection
        alert = UIAlertController(title: "Status", message: "Connecting...", preferredStyle: .alert)
               alert!.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
                   action.isEnabled = false
                   self.alert!.title   = "Aborting"
                   self.alert!.message = "Cancelling connection..."
                   bearer.close()
               })
        stopScanning()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.connection!.close()
            bearer.open()
            self.connection.proxies.append(bearer);
            self.connection.isOpen = true;
            self.proxy_connect = 0;
        }

    }
    //指定设备开关灯
    @objc public func onOffSetUnacknowledgedAndNum(index:Int , onOff:Bool) {
        if let network = meshNetworkManager.meshNetwork {
                   let notConfiguredNodes = network.nodes.filter({ !$0.isConfigComplete && !$0.isProvisioner })
                    if(notConfiguredNodes.count < 1)
                    {
                        return;
                    }
                   var myNode = notConfiguredNodes[index]
                   self.element = myNode.elements[0]
                   for item in element.models {
                        if item.modelIdentifier == 0x1000{
                            self.model = item
                            print(item.modelIdentifier)
                        }
                        if item.modelIdentifier == 0x1303{
                            self.modelCTL = item
                            print(item.modelIdentifier)
                        }
                                  
                    }
                var message: MeshMessage!
                    message = GenericOnOffSetUnacknowledged(onOff)

                start("Sending...") {
                    print("Sending...")
                    return try self.meshNetworkManager.send(message, to: self.model)
                }
            }
    }
//    设置relay
    @objc public func setRelay(index:Int , onOff:Bool) {
        if let network = meshNetworkManager.meshNetwork {
                   let notConfiguredNodes = network.nodes.filter({ !$0.isConfigComplete && !$0.isProvisioner })
                    if(notConfiguredNodes.count < 1)
                    {
                        return;
                    }
                   var myNode = notConfiguredNodes[index]
                   self.element = myNode.elements[0]
                   for item in element.models {
                        if item.modelIdentifier == 0x1000{
                            self.model = item
                            print(item.modelIdentifier)
                        }
                        if item.modelIdentifier == 0x1303{
                            self.modelCTL = item
                            print(item.modelIdentifier)
                        }
                                  
                    }
                var message: ConfigMessage!
            if onOff == true {
                let count = UInt8(5)
                let steps = UInt8(15)
                message = ConfigRelaySet(count: count, steps: steps)
            }
            if onOff == false {
                message = ConfigRelaySet()
            }
                start("Sending...") {
                    print("设置setRelay")
                    return try self.meshNetworkManager.send(message, to: self.model)
                }
            }
    }
//    获取relay
    @objc public func getRelay(index:Int , onOff:Bool) {
          if let network = meshNetworkManager.meshNetwork {
                     let notConfiguredNodes = network.nodes.filter({ !$0.isConfigComplete && !$0.isProvisioner })
                    if(notConfiguredNodes.count > 0)
                    {
                        print("index: ",index)
                         var myNode = notConfiguredNodes[index]
                                            self.element = myNode.elements[0]
                                            for item in element.models {
                                                 if item.modelIdentifier == 0x1000{
                                                     self.model = item
                                                     print(item.modelIdentifier)
                                                 }
                                                 if item.modelIdentifier == 0x1303{
                                                     self.modelCTL = item
                                                     print(item.modelIdentifier)
                                                 }
                                                           
                                             }
                                         var message: ConfigMessage!
                                         message = ConfigRelayGet()
                                         start("Sending...") {
                                             print("获取getRelay")
                                            //add by dengyiyun
                                            if(self.model != nil)   //avoid abnormal process
                                            {
                                             return try self.meshNetworkManager.send(message, to: self.model)
                                            }
                                            else
                                            {
                                                return self.messageHandle;
                                            }
                        }
                    }
                    
              }
      }
    //获取ProxyName
    @objc public func getProxyName(){
        /*
        centralManager = CBCentralManager()
        let aryUUID = ["30240020-5101-0000-6301-000065010000","A8016100-0420-0111-CF67-B35972B9DC6E"]
        var aryCBUUIDS = [CBUUID]()

        for uuid in aryUUID{
            let uuid = CBUUID(string: "30240020-5101-0000-6301-000065010000")
            aryCBUUIDS.append(uuid)
        }
        print("==",centralManager.retrieveConnectedPeripherals(withServices: aryCBUUIDS));
        print("get proxy name\n");
        */
//        print("is connected = ",peripheral.state == CBPeripheralState.connected);
        
        //add dengyiyun: to judeg whether the connection is exist or not.
        if (connection.isOpen)
        {
            print(meshNetworkManager.proxyFilter?.proxy);
            print(meshNetworkManager.proxyFilter?.proxy?.name)
            NotificationCenter.default.post(name: NSNotification.Name("ProxyName"), object:nil, userInfo:["ProxyName":meshNetworkManager.proxyFilter?.proxy?.name])
        }
        else
        {
            //should not set proxyname with nil，it will affect name display for latter
            // connection.
            NotificationCenter.default.post(name: NSNotification.Name("ProxyName"), object:nil, userInfo:nil)
        }

       }
    //设备添加分组
    @objc public func addDeviceGroup(index:Int ,name:String){
        if let network = meshNetworkManager.meshNetwork {
            let notConfiguredNodes = network.nodes.filter({ !$0.isConfigComplete && !$0.isProvisioner })
            if(notConfiguredNodes.count < 1)
            {
                return;
            }
            var myNode = notConfiguredNodes[index]
            self.element = myNode.elements[0]
            for item in element.models {
                if item.modelIdentifier == 0x1000{
                    self.model = item
                    print(item.modelIdentifier)
                }
                if item.modelIdentifier == 0x1303{
                    self.modelCTL = item
                    print(item.modelIdentifier)
                }
            }
            for group in network.groups {
                if group.name == name {
                    self.group = group
                }
            }
            let group = self.group!
            if  group.name == "" {
                print("没有获取到组")
                return
            }
            start("Subscribing...") {
                print("加入分组")
                let message: ConfigMessage =
                    ConfigModelSubscriptionAdd(group: group, to: self.model) ??
                        ConfigModelSubscriptionVirtualAddressAdd(group: group, to: self.model)!
                    return try self.meshNetworkManager.send(message, to: self.model)
            }
            
        }
      
    }
//    设备删除分组
    @objc public func deleteDeviceGroup(index:Int ,name:String){
          if let network = meshNetworkManager.meshNetwork {
              let notConfiguredNodes = network.nodes.filter({ !$0.isConfigComplete && !$0.isProvisioner })
                if(notConfiguredNodes.count < 1)
                    {
                        return;
                    }
              var myNode = notConfiguredNodes[index]
              self.element = myNode.elements[0]
              for item in element.models {
                  if item.modelIdentifier == 0x1000{
                      self.model = item
                      print(item.modelIdentifier)
                  }
                  if item.modelIdentifier == 0x1303{
                      self.modelCTL = item
                      print(item.modelIdentifier)
                  }
              }
            for group in self.model.subscriptions {
              if group.name == name {
                    self.group = group
               }
            }
            let group = self.group!
            start("Subscribing...") {
                print("退出分组")
                   let message: ConfigMessage =
                    ConfigModelSubscriptionDelete(group: group, from: self.model) ??
                    ConfigModelSubscriptionVirtualAddressDelete(group: group, from: self.model)!
                    return try self.meshNetworkManager.send(message, to: self.model)
              }
          }
        
      }
    //组开关灯
    @objc public func setGroupOnOffSetUnacknowledged(onOff:Bool ,name:String){
        let meshNetwork = meshNetworkManager.meshNetwork!
//            keys = meshNetwork.applicationKeys.notKnownTo(node: node).filter {
//                                 node.knows(networkKey: $0.boundNetworkKey)
//            }
        var applicationKey :ApplicationKey!
            applicationKey = meshNetwork.applicationKeys[0]
                         
            var messageAll: MeshMessage!
//                messageAll = GenericOnOffSetUnacknowledged(onOff,
//                             transitionTime: TransitionTime(1.0),
//                             delay: 20)
                messageAll = GenericOnOffSetUnacknowledged(onOff)
        if name == "全部设备开关灯" {
        start("111") {
            print("全部设备开关灯")
            return try self.meshNetworkManager.send(messageAll, to: MeshAddress(Address.allNodes), using: applicationKey)
        }
            return
        }
            var selectGroup: Group!
            for group in meshNetwork.groups {
                if group.name == name {
                    selectGroup = group
                }
            }
            start("111") {
                return try self.meshNetworkManager.send(messageAll, to: selectGroup, using: applicationKey)
            }
    }
//    设置灯光色温
    @objc public func setLightCTLSet(index:Int ,temperature:UInt16, lightness:UInt16) {
        if let network = meshNetworkManager.meshNetwork {
                         let notConfiguredNodes = network.nodes.filter({ !$0.isConfigComplete && !$0.isProvisioner })
                        if(notConfiguredNodes.count < 1)
                        {
                            return;
                        }
                         var myNode = notConfiguredNodes[index]
                         self.element = myNode.elements[0]
                         for item in element.models {
                              if item.modelIdentifier == 0x1000{
                                  self.model = item
                                  print(item.modelIdentifier)
                              }
                              if item.modelIdentifier == 0x1303{
                                  self.modelCTL = item
                                  print(item.modelIdentifier)
                              }
                          }
                     var message: MeshMessage!
                        message = LightCTLSet(lightness: lightness, temperature: temperature, deltaUV: 0x0800)
                    start("Sending...") {
                            print("Sending...")
                            return try self.meshNetworkManager.send(message, to: self.modelCTL)
                    }
        }
    }
    // 设置HSL
    @objc public func setLightHSLSet(index:Int ,saturation:UInt16, lightness:UInt16,hue:UInt16) {
        if let network = meshNetworkManager.meshNetwork {
                         let notConfiguredNodes = network.nodes.filter({ !$0.isConfigComplete && !$0.isProvisioner })
                        if(notConfiguredNodes.count < 1)
                        {
                            return;
                        }
                         var myNode = notConfiguredNodes[index]
                         self.element = myNode.elements[0]
                         for item in element.models {
                              if item.modelIdentifier == 0x1000{
                                  self.model = item
                                  print(item.modelIdentifier)
                              }
                              if item.modelIdentifier == 0x1303{
                                  self.modelCTL = item
                                  print(item.modelIdentifier)
                              }
                            if item.modelIdentifier == 0x1307{
                                self.modelHSL = item
                                print(item.modelIdentifier)
                            }
                                        
                          }
            if (self.modelHSL != nil) {
                 var message: MeshMessage!
                    message = LightHSLSet(lightness: lightness, hue: hue, saturation: saturation)
                    start("Sending...") {
                    print("Sending...")
                    return try self.meshNetworkManager.send(message, to: self.modelHSL)
                }
            }
        }
    }
    // 设置程序码
    @objc public func setNumber(index:Int ,number:UInt16) {
        if let network = meshNetworkManager.meshNetwork {
                         let notConfiguredNodes = network.nodes.filter({ !$0.isConfigComplete && !$0.isProvisioner })
                        if(notConfiguredNodes.count < 1)
                        {
                            return;
                        }
                         var myNode = notConfiguredNodes[index]
                         self.element = myNode.elements[0]
                         for item in element.models {
                              if item.modelIdentifier == 0x1000{
                                  self.model = item
                                  print(item.modelIdentifier)
                              }
                              if item.modelIdentifier == 0x1303{
                                  self.modelCTL = item
                                  print(item.modelIdentifier)
                              }
                            if item.modelIdentifier == 0x1307{
                                self.modelHSL = item
                                print(item.modelIdentifier)
                            }
                            if item.modelIdentifier == 0x1306{
                                self.modelNumber = item
                                print(item.modelIdentifier)
                            }
                          
                          }
            if(self.modelNumber != nil){
                 var message: MeshMessage!
                    message = LightCTLTemperatureSet(temperature: number, deltaUV: 0x0800)
                    start("Sending...") {
                        print("Sending...")
                        return try self.meshNetworkManager.send(message, to: self.modelNumber)
                }
            }
        }
    }
//    新建分组
    @objc public func setNewGroupAndName(str:String) {
        if let network = meshNetworkManager.meshNetwork,
                  let localProvisioner = network.localProvisioner {
                   // Try assigning next available Group Address.
                   if let automaticAddress = network.nextAvailableGroupAddress(for: localProvisioner) {
                       name = str
                       address = MeshAddress(automaticAddress)
                   } else {
                       // All addresses from Provisioner's range are taken.
                       // A Virtual Label has to be used instead.
                       name = str
                       address = MeshAddress(UUID())
                   }
            if let name = name, let address = address {
                do{
                let group = try Group(name: name, address: address)
                let network = meshNetworkManager.meshNetwork!
                try network.add(group: group)
                if meshNetworkManager.save() {
                    print("新建 group 成功")
                    self.group = group
                } else {
                    print("新建 group 失败")
                }
               }
                catch{
                    print("新建 group 失败 catch")

                }
            }
        }
    }
//    修改分组名称
    @objc public func modifyGroupAndName(str:String ,newStr:String) {
        let meshNetwork = meshNetworkManager.meshNetwork!
        var selectGroup: Group!
        for group in meshNetwork.groups {
            if group.name == str {
                selectGroup = group
            }
        }
        selectGroup.name = newStr
        if meshNetworkManager.save() {
            self.group = selectGroup
            print("修改 group 成功")
        } else {
            print("修改 group 失败")
        }
        
    }
//    删除分组
    @objc public func removeGroupAndName(str:String) {
         let meshNetwork = meshNetworkManager.meshNetwork!
         var selectGroup: Group!
         for group in meshNetwork.groups {
            if group.name == str {
                selectGroup = group
            }
         }
        do {
            try meshNetwork.remove(group: selectGroup)
            if meshNetworkManager.save() {
                print("删除组成功")
            } else {
                print("Error Mesh configuration could not be saved.")
            }
        } catch {
            print("Error Mesh configuration ")
        }
    }
//    删除指定设备
     @objc public func removeDeviceNode(index:Int){
        if let network = meshNetworkManager.meshNetwork {
                let notConfiguredNodes = network.nodes.filter({ !$0.isConfigComplete && !$0.isProvisioner })
                if(notConfiguredNodes.count < 1)
                {
                    return;
                }
                let myNode = notConfiguredNodes[index]
                    start("Resetting node...") {
                        print("Resetting node...")
                        let message = ConfigNodeReset()
                        self.nodeReset = myNode;
//  remove below code by dengyiyun, wait for node reset status and then delete the device.
//                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
//                            self.meshNetworkManager.meshNetwork!.remove(node: self.nodeReset)
//                            if self.meshNetworkManager.save() {
//                                print("删除设备成功.")
//                            } else {
//                                print("删除设备失败")
//                            }
//                        }
                      
                        return try self.meshNetworkManager.send(message, to: myNode)
                    }

                }
    }
    
    //    强制删除本地设备
         @objc public func removeDeviceNodelocal(index:Int){
            if let network = meshNetworkManager.meshNetwork {
                    let notConfiguredNodes = network.nodes.filter({ !$0.isConfigComplete && !$0.isProvisioner })
                    if(notConfiguredNodes.count < 1)
                    {
                        return;
                    }
               let myNode = notConfiguredNodes[index]
                    start("Resetting node..."){
                        print("Resetting node locally...")
                        let message = ConfigNodeReset()
                        self.nodeReset = myNode;
                
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                            self.meshNetworkManager.meshNetwork!.remove(node: self.nodeReset)
                            if self.meshNetworkManager.save() {
                                print("删除设备成功.")
                            } else {
                                print("删除设备失败")
                            }
                        }
              
                        return try self.meshNetworkManager.send(message, to: myNode)
                        }
        }
    }
    //   搜索已入网设备
    @objc public func myDevice() {
        if let network = meshNetworkManager.meshNetwork {
                   let notConfiguredNodes = network.nodes.filter({ !$0.isConfigComplete && !$0.isProvisioner })
                   var dicArray = [Any]()
                   if !notConfiguredNodes.isEmpty {
                    for item in notConfiguredNodes {
                        var dictM = [String : String]()
                        dictM["name"] = item.name
                        dictM["uuid"] =  item.uuid.uuidString
                        dicArray.append(dictM)
                    }
                }
                print("myDeviceFinded ==  ",dicArray);
                PandroBlueToothMeshMgrBridge.shareInstance().myDeviceFinded(dicArray);
               }
            
    }
    func disconnectLastDevice()
    {
        print("disconnectLastDevice")

    }
    func setProvisioningManager()
    {
        let manager = meshNetworkManager
//        Obtain the Provisioning Manager instance for the Unprovisioned Device.
        provisioningManager = try! manager?.provision(unprovisionedDevice: discoveredPeripherals[self.indexSelect].device, over: self.bearer)
        provisioningManager.delegate = self
        provisioningManager.logger = meshNetworkManager.logger
        self.bearer.delegate = self
        if provisioningManager.networkKey == nil {
            print("networkKeyCell.selectionStyle")
        }
        do{
            try  provisioningManager.identify(andAttractFor: PandroBlueToothMeshMgrSwift.attentionTimer)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.startProvisioning()
            }
        }
        catch {
            print("Error")
            self.bearer.close()
        }
        print("provisioningManager")
        
//        }
    }
    func startProvisioning() {
                guard let capabilities = provisioningManager.provisioningCapabilities else {
                    print("return")
                    return
                }
                let publicKeyNotAvailable = capabilities.publicKeyType.isEmpty
                guard publicKeyNotAvailable || publicKey != nil else {
        //                   presentOobPublicKeyDialog(for: unprovisionedDevice) { publicKey in
        //                       self.publicKey = publicKey
        //                       self.startProvisioning()
        //                   }
                    print("publicKey = nil")
                           return
                       }
                
                publicKey = publicKey ?? .noOobPublicKey
                       
                       // If any of OOB methods is supported, if should be chosen.
                       let staticOobNotSupported = capabilities.staticOobType.isEmpty
                       let outputOobNotSupported = capabilities.outputOobActions.isEmpty
                       let inputOobNotSupported  = capabilities.inputOobActions.isEmpty
                       guard (staticOobNotSupported && outputOobNotSupported && inputOobNotSupported) || authenticationMethod != nil else {
        //                   presentOobOptionsDialog(for: provisioningManager, from: provisionButton) { method in
        //                       self.authenticationMethod = method
        //                       self.startProvisioning()
        //                   }
                            print("authenticationMethod = nil")
                           return
                       }
                
                // If none of OOB methods are supported, select the only option left.
                      if authenticationMethod == nil {
                          authenticationMethod = .noOob
                      }
                      
                      if provisioningManager.networkKey == nil {
                          let network = meshNetworkManager.meshNetwork!
                          let networkKey = try! network.add(networkKey: OpenSSLHelper().generateRandom(), name: "Primary Network Key")
                          provisioningManager.networkKey = networkKey
                      }
                      
                      // Start provisioning.
        //              presentStatusDialog(message: "Provisioning...") {
                            NotificationCenter.default.post(name: NSNotification.Name("logDevice"), object: nil, userInfo: ["log":"连接设备成功，设备开始入网！"])

                          do {
                              try self.provisioningManager.provision(usingAlgorithm:       .fipsP256EllipticCurve,
                                                                     publicKey:            self.publicKey!,
                                                                     authenticationMethod: self.authenticationMethod!)
                          } catch {
                            print("Error localizedDescription")

                          }
    }
    func showModel() {
//        meshNetworkDidChange()
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
        self.showNewModel()
//        }

       

    }
    func showNewModel() {
        print("newModel")
        if meshNetworkManager.save() {
                   let network = meshNetworkManager.meshNetwork!
                   if let nodeOne = network.node(for:  discoveredPeripherals[self.indexSelect].device) {
                       self.node = nodeOne;
                       print("node secees")
                       let localProvisioner = meshNetworkManager.meshNetwork?.localProvisioner
                           guard localProvisioner?.hasConfigurationCapabilities ?? false else {
                           // The Provisioner cannot sent or receive messages.
                               return
                           }
                       
                       // If the Composition Data were never obtained, get them now.
                       if !node.isCompositionDataReceived {
                           // This will request Composition Data when the bearer is open.
                        print("get composition\n")
                           getCompositionData()
                       } else if node.defaultTTL == nil {
                           getTtl()
                       }
                   }
               } else {
                   print("Mesh configuration could not be saved.")
               }
        
    }
   


}
private extension PandroBlueToothMeshMgrSwift {
    
    @objc func getCompositionData() {
            start("Requesting Composition Data...") {
                  let message = ConfigCompositionDataGet()
                return try self.meshNetworkManager.send(message, to: self.node)
              }
       }
       
       func getTtl() {
            start("Requesting default TTL...") {
                let message = ConfigDefaultTtlGet()
                return try self.meshNetworkManager.send(message, to: self.node)
            }
        }
    func start(_ message: String, completion: @escaping (() throws -> MessageHandle?)) {
           DispatchQueue.main.async {
                      do {
                          self.messageHandle = try completion()
                          guard let _ = self.messageHandle else {
                              self.done()
                              return
                          }
                      } catch {
                        let completition: () -> Void = {
                        }
                        completition()
                      }
                  }
    }
    func done(completion: (() -> Void)? = nil) {
               DispatchQueue.main.async {
                   completion?()
               }
    }
          
}




extension MeshNetworkManager {
    static var instance: MeshNetworkManager {
        return (self as! PandroBlueToothMeshMgrSwift).meshNetworkManager
    }

    static var bearer: NetworkConnection! {
        return (self as! PandroBlueToothMeshMgrSwift).connection
    }

}

// MARK: - Logger

extension PandroBlueToothMeshMgrSwift: LoggerDelegate {
    
    func log(message: String, ofCategory category: LogCategory, withLevel level: LogLevel) {
        if #available(iOS 10.0, *) {
            os_log("%{public}@", log: category.log, type: level.type, message)
        } else {
            NSLog("%@", message)
        }
    }
    
}

extension LogLevel {
    
    /// Mapping from mesh log levels to system log types.
    var type: OSLogType {
        switch self {
        case .debug:       return .debug
        case .verbose:     return .debug
        case .info:        return .info
        case .application: return .default
        case .warning:     return .error
        case .error:       return .fault
        }
    }
    
}

extension LogCategory {
    
    var log: OSLog {
        return OSLog(subsystem: Bundle.main.bundleIdentifier!, category: rawValue)
    }
    
}


// MARK: - GattBearerDelegate

extension PandroBlueToothMeshMgrSwift: GattBearerDelegate {
    
    func bearerDidConnect(_ bearer: Bearer) {
        print("Discovering services...")
    }
    
    func bearerDidDiscoverServices(_ bearer: Bearer) {
        //dengyiyun: here to add the proxies to networkconnectio
        print("Initializing...")
    }
        
    func bearerDidOpen(_ bearer: Bearer) {
        print("bearerDidOpen")
        if(proxy_connect==0)
        {
            self.bearer = bearer as? ProvisioningBearer;
            self.setProvisioningManager()
        }
    }
    
    func bearer(_ bearer: Bearer, didClose error: Error?) {
        print(" Device disconnected")
        if error != nil {
            print("GattBearerDelegate Device bearer error")
            return
        }
        guard case .complete = provisioningManager.state else {
                   print("GattBearerDelegate Device disconnected.")
                      return
                  }
                   print("Success  Provisioning complete.")
        NotificationCenter.default.post(name: NSNotification.Name("logDevice"), object: nil, userInfo: ["log":"设备入网成功，准备配置设备功能！"])
        if(self.proxy_connect == 0)
        {
            self.showModel()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            print("value ",self.connectingArray[self.connectingArrayIndex].intValue);
            self.connectProxyNode(index: self.connectingArray[self.connectingArrayIndex].intValue);
            self.proxy_connect = 1;
            }
        }
        else
        {
            self.proxy_connect = 0;
            print("proxy_connect reset");
            discoveredPeripherals .removeAll();
        }
    }

}

// MARK: - CBCentralManagerDelegate

extension PandroBlueToothMeshMgrSwift: CBCentralManagerDelegate {
//    开始搜索设备
    private func startScanning() {
        connection.centralManager.delegate = self
        connection.centralManager.scanForPeripherals(withServices: [MeshProvisioningService.uuid],
                                          options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
    }
//    停止搜索设备
    private func stopScanning() {
        connection.centralManager.delegate = connection
        connection.centralManager.stopScan()
    
    }
//    检索到设备的回调
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let index = discoveredPeripherals.firstIndex(where: { $0.peripheral == peripheral }) {
         
        } else {
            if let unprovisionedDevice = UnprovisionedDevice(advertisementData: advertisementData) {
//                刷新ui展示设备
                discoveredPeripherals.append((unprovisionedDevice, peripheral, RSSI.intValue))
                print("deng discover append %s\n",peripheral.name);
                PandroBlueToothMeshMgrBridge.shareInstance().unprovisionDeviceFinded(peripheral);
            }
        }
        
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state != .poweredOn {
            print("Central is not powered on")
        } else {
            startScanning()
        }
    }
         
}


extension PandroBlueToothMeshMgrSwift: ProvisioningDelegate {
    //每当设置状态更改时调用回调。
    func provisioningState(of unprovisionedDevice: UnprovisionedDevice, didChangeTo state: ProvisionigState) {
        DispatchQueue.main.async {
            switch state {
                
            case .requestingCapabilities:
                print("request capa")
            case .capabilitiesReceived(let capabilities):

                let addressValid = self.provisioningManager.isUnicastAddressValid == true
                if !addressValid {
                   self.provisioningManager.unicastAddress = nil
                }

                let deviceSupported = self.provisioningManager.isDeviceSupported == true
                
            case .complete:
                print("complete")
                self.bearer.close()
                
            case let .fail(error):
                print("111")
                
            default:
                break
            }
        }
    }
    ///需要身份验证操作时调用回调
    func authenticationActionRequired(_ action: AuthAction) {
        switch action {
        case let .provideStaticKey(callback: callback):
            print("222222")
        case let .provideNumeric(maximumNumberOfDigits: _, outputAction: action, callback: callback):
            print("333333")
        case let .provideAlphanumeric(maximumNumberOfCharacters: _, callback: callback):
            print("44444")
        case let .displayAlphanumeric(text):
            print("55555")
        case let .displayNumber(value, inputAction: action):
            print("666666")
        }
    }
    
    func inputComplete() {
    }
    
}
extension PandroBlueToothMeshMgrSwift: MeshNetworkDelegate {
    
       func meshNetworkManager(_ manager: MeshNetworkManager, didSendMessage message: MeshMessage,
                               from localElement: Element, to destination: Address) {
           done()
       }
       
       func meshNetworkManager(_ manager: MeshNetworkManager, failedToSendMessage message: MeshMessage,
                               from localElement: Element, to destination: Address, error: Error) {
           done() {
            print("")
            
        }
       }
    
    func meshNetworkManager(_ manager: MeshNetworkManager,
                            didReceiveMessage message: MeshMessage,
                            sentFrom source: Address, to destination: Address) {
        // Has the Node been reset remotely.
        guard !(message is ConfigNodeReset) else {
            print("return")

            return
        }

        switch message {
            
        case is ConfigCompositionDataStatus:
            print("get composition status\n")
            self.getTtl()
            self.element = self.node.elements[0]
            for item in element.models {
                if item.modelIdentifier == 0x1000{
                    self.model = item
                    print(item.modelIdentifier)
                }
                if item.modelIdentifier == 0x1303{
                    self.modelCTL = item
                    print(item.modelIdentifier)
                }
                if item.modelIdentifier == 0x1306{
                    self.modelNumber = item
                    print(item.modelIdentifier)
                }
                if item.modelIdentifier == 0x1307{
                    self.modelHSL = item
                    print(item.modelIdentifier)
                }
                
            }
            
            let meshNetwork = meshNetworkManager.meshNetwork!
            
            try! meshNetwork.add(applicationKey: self.data, name: "123")

            keys = meshNetwork.applicationKeys.notKnownTo(node: node).filter {
                node.knows(networkKey: $0.boundNetworkKey)
            }
            
            let selectedAppKey = keys[0]
            
//            let group = meshNetwork.groups[0]
//                start("Subscribing...") {
//                    print("加入分组")
//                    let message: ConfigMessage =
//                        ConfigModelSubscriptionAdd(group: group, to: self.model) ??
//                        ConfigModelSubscriptionVirtualAddressAdd(group: group, to: self.model)!
//                    return try self.meshNetworkManager.send(message, to: self.model)
//                }
//
            start("Adding Application Key...") {
                print("Adding Application Key...")
            NotificationCenter.default.post(name: NSNotification.Name("logDevice"), object: nil, userInfo: ["log":"获取设备功能成功，给设备添加程序密钥"])
                return try self.meshNetworkManager.send(ConfigAppKeyAdd(applicationKey: selectedAppKey), to: self.node)
            }
        case is ConfigDefaultTtlStatus:
            print("")
        
        case is ConfigNodeResetStatus:
            print("node reset status\n")
            //add by dengyiyun , remove the device from list
                self.meshNetworkManager.meshNetwork!.remove(node: self.nodeReset)
                if self.meshNetworkManager.save() {
                    print("删除设备成功.")
                } else {
                    print("删除设备失败")
                }
            //added by dengyiyun for bug.
            if (source == meshNetworkManager.proxyFilter?.proxy?.unicastAddress)
            {
                print("remove proxy node\n");
                meshNetworkManager.proxyFilter?.proxy?.name = nil;
               // meshNetworkManager.proxyFilter?.proxy?.unicastAddress=0xffff;
                print("")
            }
            
        case let status as ConfigAppKeyStatus:
            guard node.unicastAddress == source else {
                return
            }
            if status.status == .success {
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                    print("ConfigAppKeyStatusT")
                    print(self.keysCTL);
                    print(self.modelCTL);
                    //updated by dengyiyun ,check the modelCTL exit or not
                    if(self.modelCTL == nil)
                    {
                        return;
                    }
                    self.keysCTL = self.modelCTL.parentElement?.parentNode?.applicationKeysAvailableFor(self.modelCTL)
                    
                    if (self.keysCTL.count > 0){//fix crash
                        let selectedAppKeyCTL = self.keysCTL[0]
                        guard let messageTCL = ConfigModelAppBind(applicationKey: selectedAppKeyCTL, to: self.modelCTL) else {
                            return
                        }
                        self.start("Binding Application Key...CTL") {
                            print("Binding Application KeyCTL")
                            return try self.meshNetworkManager.send(messageTCL, to: self.modelCTL)
                        }
                    }
                    
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                    if(self.modelHSL != nil)
                    {
                              self.keysHSL = self.modelHSL.parentElement?.parentNode?.applicationKeysAvailableFor(self.modelHSL)
                            if (self.keysHSL.count > 0){//fix crash
                                let selectedAppKeyHSL = self.keysHSL[0]
                                guard let messageHSL = ConfigModelAppBind(applicationKey: selectedAppKeyHSL, to: self.modelHSL) else {
                                    return
                                }
                                self.start("Binding Application Key...HSL") {
                                    print("Binding Application KeyHSL")
                                    return try self.meshNetworkManager.send(messageHSL, to: self.modelHSL)
                                }
                            }  
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6) {
                    if(self.modelNumber != nil)
                    {
                              self.keysNumber = self.modelNumber.parentElement?.parentNode?.applicationKeysAvailableFor(self.modelNumber)
                              let selectedAppKeyNumber = self.keysNumber[0]
                              guard let messageNumber = ConfigModelAppBind(applicationKey: selectedAppKeyNumber, to: self.modelNumber) else {
                                  return
                              }
                              self.start("Binding Application Key...Number") {
                                  print("Binding Application Number")
                                  return try self.meshNetworkManager.send(messageNumber, to: self.modelNumber)
                              }
                    }
                }
                keys = self.model.parentElement?.parentNode?.applicationKeysAvailableFor(self.model)
                let selectedAppKey = keys[0]
                guard let message = ConfigModelAppBind(applicationKey: selectedAppKey, to: self.model) else {
                          return
                }
                start("Binding Application Key...") {
                    print("Binding Application Key")
                    NotificationCenter.default.post(name: NSNotification.Name("logDevice"), object: nil, userInfo: ["log":"添加程序密钥成功，给设备功能绑定key！"])

                    return try self.meshNetworkManager.send(message, to: self.model)
                }

            } else {
                print("ConfigAppKeyStatusF")
            }
            
            case let status as ConfigModelAppStatus:
                guard model.parentElement?.parentNode?.unicastAddress == source else {
                    return
                }
                if status.status == .success {
                    print("ConfigModelAppStatusT")
//                    self.setLightCTLSet()
//                    self.meshNetworkManager.send(message, description: "Sending...")
                    DispatchQueue.main.async {
                        PandroBlueToothMeshMgrBridge.shareInstance().blueToothDevicesMeshProxySucceed();
                    }
                } else {
                    print("ConfigModelAppStatusF")

                }
            case let status as ConfigRelayStatus:
                var str = "0"
                if status.state == NodeFeaturesState.notEnabled {
                    str = "0"
                }
                if status.state == NodeFeaturesState.enabled {
                    str = "1"
                }
                if status.state == NodeFeaturesState.notSupported {
                    str = "2"
                }
                NotificationCenter.default.post(name: NSNotification.Name("changeRelay"), object: nil, userInfo: ["changeRelay":str])

            print("RelayStatus")
//            case is ConfigNodeResetStatus:
//                meshNetworkManager.meshNetwork!.remove(node: self.nodeReset)
//                if meshNetworkManager.save() {
//                    print("删除设备成功.")
//                    NotificationCenter.default.post(name: NSNotification.Name("changeRelay"), object: nil, userInfo: ["removeDeviceNode":"1"])
//                } else {
//                    print("删除设备失败")
//                }
//
        default:
            break
        }
    }
    
}


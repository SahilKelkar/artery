package artery.inet;

import inet.linklayer.ethernet.EthernetInterface;

module EtherNic extends EthernetInterface
{
    parameters:
       

       mac.duplexMode = true;
	fcsMode = "";
	mac.typename = "EtherMac";
	encap.typename = "EtherEncap";
}

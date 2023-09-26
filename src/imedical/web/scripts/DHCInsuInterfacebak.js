


function OPRevBJMzTb(strPRTINVStr){
	return -1;	
}

/*

function OPRevBJMzTb(strPRTINVStr){
	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.clsBasBILLBJFacade");  

///BasPatientBill
	var rtnStr=-1;
	var rtnStr=DHCINSUBLL.OPRev(strPRTINVStr,"0","");
	var tmpField=rtnStr.split("|");

	var Tczf=String.fromCharCode(2)+""+"^"+tmpField[3];
	var Dezf=String.fromCharCode(2)+""+"^"+tmpField[4];
	var Ybwc=String.fromCharCode(2)+""+"^"+tmpField[5];
	var Xjzf=""+"^"+tmpField[6];
	var DivideRowId=tmpField[1];
	var InvprtDr=tmpField[2];
	var Flag=tmpField[0];
	var rtnStr=Flag+"^"+DivideRowId+"^"+Xjzf+"^"+InvprtDr+Tczf+Dezf+Ybwc
    return rtnStr;
	
}
*/

function OPRevBJMzTbPark(DivideDr)

{	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.clsBasBILLBJFacade");  

///BasPatientBill
	var rtnStr=-1;
	var rtnStr=DHCINSUBLL.OPRevFootBack(strDivideDr);	
	if (rtnStr!=0)  {return -1;}	
	return 0;
	
	}


function IPRevOutPut(strBillDr){
        var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.clsBasBILLBJFacade");
	var rtnStr=-1;
	var rtnStr=DHCINSUBLL.IPRevOutPut(strBillDr);	
	return rtnStr;	
		
}

function IPRevFoot(strBillDr,InsuType)
{	
	if(InsuType==t['INSUPatType']||InsuType==t['INSUPatType03']||InsuType==t['INSUPatType04']||InsuType==t['INSUPatType05']||InsuType==t['INSUPatType06']){
	   var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.clsBasBILLBJFacade");  
	};
	if(InsuType==t['INSUPatType07']){
	   var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.clsBasBILLBJBFacade");  
	};
	if(InsuType==t['INSUPatType02']){
	   var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.clsBasBILLBJCFacade");  
	};
    ///BasPatientBill
	var rtnStr=-1;
	var rtnStr=DHCINSUBLL.IPRevFoot(strBillDr);	
	DHCINSUBLL=null;
	if (rtnStr<0)  {return -1;}			
    return rtnStr;
	}
	
function IPRevFootBack(strBillDr){
	
	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.clsBasBILLBJFacade");  

    ///BasPatientBill
	var rtnStr=-1;
	var rtnStr=DHCINSUBLL.IPRevFootBack(strBillDr);	
	if (rtnStr!=0)  {return -1;}	
	return 0;	
	}
		
function MzsfybNBA(strPRTINVStr){
    var tmpFields=strPRTINVStr.split("^")
	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.clsBasBILLNBAFacade");  

///BasPatientBill
	var rtnStr=-1;
	alert(tmpFields[0])
	var rtnStr=DHCINSUBLL.OPRev(tmpFields[0],"");
	if (rtnStr=="Cancle") {return -1;}
	if (rtnStr<0)  {return -1;}	
	var tmpField=rtnStr.split("|")
	//alert("tmpField[37]:"+tmpField[38])
	//alert("tmpField[38]:"+tmpField[39])
	var PatShareSum=eval(tmpField[1])+eval(tmpField[2])+eval(tmpField[3])+eval

(tmpField[4])
	//var cashA=5+"^"+tmpField[1]+String.fromCharCode(2)
	//var cashB=6+"^"+tmpField[2]+String.fromCharCode(2)
	//var cashC=7+"^"+tmpField[3]+String.fromCharCode(2)
	//var cashD=8+"^"+tmpField[4]+String.fromCharCode(2)
	var GBJJZF=9+"^"+tmpField[12]+String.fromCharCode(2)
	var TCZF=10+"^"+tmpField[13]+String.fromCharCode(2)
	var JZZF=11+"^"+tmpField[14]+String.fromCharCode(2)
	var SHJZZF=12+"^"+tmpField[16]+String.fromCharCode(2)
	var DNGZ=13+"^"+tmpField[38]+String.fromCharCode(2)
	var LNGZ=14+"^"+tmpField[39]+String.fromCharCode(2)
	var BackStr=tmpField[0]+"^"+tmpField[33]+"^"+PatShareSum+"^"+tmpField[37]

+String.fromCharCode(2)
	var myYBInfo=BackStr+GBJJZF+TCZF+JZZF+SHJZZF+DNGZ+LNGZ
	return myYBInfo;
	}
	
function MzsfcxybPark(strINSDivDR)
{
	//alert("MzsfcxybPark")
	//alert(strINSDivDR)
	var rtn="-1"
	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.clsBasBILLNBAFacade");  

///BasPatientBill
	var rtnStr=-1;
	var rtnStr=DHCINSUBLL.OPPayBack(strINSDivDR,"","","OPRev");
	if (rtnStr=="Cancle") {return -1;}
	if (rtnStr<0)  {return -1;}	
	var tmpField=rtnStr.split("|")
	var rtn=tmpField[0]
	return rtn;
	}
	
function OPRegPark(strAdmDr)
{
	alert("OPRegPark")
	alert(strAdmDr)
	var rtn="-1"
	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.clsBasBILLNBAFacade");  

///BasPatientBill
	var rtnStr=-1;
	var rtnStr=DHCINSUBLL.OPRegPayBack(strAdmDr,"","","OPReg");
	if (rtnStr=="Cancle") {return -1;}
	if (rtnStr<0)  {return -1;}	
	var tmpField=rtnStr.split("|")
	var rtn=tmpField[0]
	return rtn;
	}	


function InsuFileInput()
{
    var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.clsBasBILLBJDFacade");  
    var rtn=DHCINSUBLL.InsuFileInput();
	}
	
function OPRegNBA(strRegDr){
	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.clsBasBILLNBAFacade");  

///BasPatientBill
	var rtnStr=-1;
	var rtnStr=DHCINSUBLL.OPReg(strRegDr,"");
	if (rtnStr=="Cancle") {return -1;}
	if (rtnStr<0)  {return -1;}	
	var tmpField=rtnStr.split("|")
	//alert(rtnStr)
    //alert("tmpField[38]:"+tmpField[38])
	//alert("tmpField[39]:"+tmpField[39])
	var PatShareSum=eval(tmpField[1])+eval(tmpField[2])+eval(tmpField[3])+eval

(tmpField[4])
	//var cashA=5+"^"+tmpField[1]+String.fromCharCode(2)
	//var cashB=6+"^"+tmpField[2]+String.fromCharCode(2)
	//var cashC=7+"^"+tmpField[3]+String.fromCharCode(2)
	//var cashD=8+"^"+tmpField[4]+String.fromCharCode(2)
	var GBJJZF=9+"^"+tmpField[12]+String.fromCharCode(2)
	var TCZF=10+"^"+tmpField[13]+String.fromCharCode(2)
	var JZZF=11+"^"+tmpField[14]+String.fromCharCode(2)
	var SHJZZF=12+"^"+tmpField[16]+String.fromCharCode(2)
	var DNGZ=13+"^"+tmpField[38]+String.fromCharCode(2)
	var LNGZ=14+"^"+tmpField[39]+String.fromCharCode(2)
	var BackStr=tmpField[0]+"|"+tmpField[33]+"|"+tmpField[34]

+"|"+PatShareSum+"^"+tmpField[37]+String.fromCharCode(2)
	var myYBInfo=BackStr+GBJJZF+TCZF+JZZF+SHJZZF
	var cashsum=1+"^"+PatShareSum+String.fromCharCode(2)
	myYBInfo=myYBInfo+String.fromCharCode(3)

+cashsum+GBJJZF+TCZF+JZZF+SHJZZF+DNGZ+LNGZ
	return myYBInfo;
	}	
	

	function trim(s) {
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
        return (m == null) ? "" : m[1];
}

	
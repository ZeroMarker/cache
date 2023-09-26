//DHCInsuLocInfo.js
//Create by yangjianzhang
//用于医保人员名单维护
var TariType=""				///设置默认的医保类型
var iSeldRow=0
var Rowidobj="",XXLXobj="",YLZBHobj="",YLZZTobj="",SBCARDobj="",TXMobj="",SFZHobj=""
var Nameobj="",XBobj="",CSNYobj="",FYIDobj="",FFXZIDobj="",RZIDobj=""
var JBIDobj="",BZNYobj="",YYDHobj="",DWDMobj="",DWXZDMobj="",DWMCobj=""
var DWDZobj="",DWDHobj="",DWYBobj="",JTZZobj="",ZZDHobj="",ZZYBobj=""
var StaDateobj="",EndDateobj="",YearStrDateobj="",MZQFDobj="",MZLJobj=""
var ZYQFXobj="",NDLJobj="",ZYCSobj="",TZLXobj="",ZCYYDMobj="",ZCKSMCobj=""
var ZCBQMCobj="",ZCCWBHobj="",ZRYYDHobj="",ZRKSMCobj="",ZRBQMCobj=""
var AdmReasonobj=""
var SSAdmReason=""
var AdmReasonID="" //王统尧 2012-04-05 维护类别 rowid
var tAdmReaDesc="";
function BodyLoadHandler() {
	var obj=document.getElementById("Query");
	if (obj){ obj.onclick=Query_click;}
	var obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click;}
	var obj=document.getElementById("Add");
	if (obj){ obj.onclick=Add_click;}
	var obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click;}
	
	/*//Zhan 20141209增加页面导入EXCEL功能(调用原来CSP文件中的函数)
	var obj=document.getElementById("btnImport");
	if (obj){ obj.onclick=function(){
		var OpenFileObj=document.getElementById("OpenFile");
		if(OpenFileObj.length<8){
			alert("请输入要导入的EXCEL文件名!");
			return;
		}else{
			var tmpfile=""
			tmpfile=OpenFileObj.value.split("\\").join("//");
			//alert(tmpfile)
			var tmplg=tmpfile.split(".").length
			if(tmplg<2){
				alert("请输入正确的文件名,比如:  c:\\import.xls")
				return;
			}else{
				var tmpexn=tmpfile.split(".")[tmplg-1].toUpperCase()
				if(("XLS"!=tmpexn)&("XLSX"!=tmpexn)){alert("请输入正确的文件名,比如:  c:\\import.xls");return;}
			}
			InPut(OpenFileObj.value);
		}
		
	};}*/
	
	// DingSH 20160504 
	var obj=document.getElementById("btnImport");
	if (obj){ obj.onclick=ImportBdInfo_onclick;}
	
	iniForm();
}
	
function ItemsClear(){
	TariType=""				///设置默认的医保类型
	
	Rowidobj.value="",YLZBHobj.value="",YLZZTobj.value="",SBCARDobj.value="",TXMobj.value="",SFZHobj.value=""
	Nameobj.value="",XBobj.value="",CSNYobj.value="",FYIDobj.value="",FFXZIDobj.value="",RZIDobj.value=""
	JBIDobj.value="",BZNYobj.value="",YYDHobj.value="",DWDMobj.value="",DWXZDMobj.value="",DWMCobj.value=""
	DWDZobj.value="",DWDHobj.value="",DWYBobj.value="",JTZZobj.value="",ZZDHobj.value="",ZZYBobj.value=""
	StaDateobj.value="",EndDateobj.value="",YearStrDateobj.value="",ZRKSMCobj.value="",ZCBQMCobj.value=""
	websys_$('AdmReason').value="",AdmReasonID="",ZCCWBHobj.value="",ZRYYDHobj.value="",ZCKSMCobj.value="",ZRBQMCobj.value=""
	DWMCobj.value="",MZLJobj.value="",ZCYYDMobj.value="",XXLXobj.value=""
	/*,MZQFDobj.value="",MZLJobj.value=""
	ZYQFXobj.value="",NDLJobj.value="",ZYCSobj.value="",TZLXobj.value="",ZCYYDMobj.value=""
	ZCBQMCobj.value="",ZRYYDHobj.value="",ZRKSMCobj.value="",ZRBQMCobj.value=""*/
	iniForm(); //tangzf 2019-10-13 清空后还原表单为初始状态
	
}
function iniForm(){
	Rowidobj=document.getElementById("Rowid");
	XXLXobj=document.getElementById("XXLX");
	AdmReasonobj=document.getElementById("AdmReason"); //费别
	if (AdmReasonobj){AdmReasonobj.value=""}
	YLZBHobj=document.getElementById("YLZBH");	//保健号
	//if (YLZBHobj){YLZBHobj.value=""}
	YLZZTobj=document.getElementById("YLZZT");	//医疗证状态
	if (YLZZTobj){YLZZTobj.value=""}
	SBCARDobj=document.getElementById("SBCARD");	//社保卡号
	if (SBCARDobj){SBCARDobj.value=""}
	TXMobj=document.getElementById("TXM");		//条形码
	if (TXMobj){TXMobj.value=""}
	SFZHobj=document.getElementById("SFZH");	//身份证号码
	if (SFZHobj){SFZHobj.value=""}
	Nameobj=document.getElementById("Name");	//病人姓名
	//if (Nameobj){Nameobj.value=""}
	XBobj=document.getElementById("XB");	///性别
	if (XBobj){
		XBobj.size=1; 
		XBobj.multiple=false;	
		XBobj.options[0]=new Option(t['Sex1'],"男");
	  	XBobj.options[1]=new Option(t['Sex2'],"女");
	  	XBobj.options[2]=new Option(t['Sex9'],"未知");
	}
	CSNYobj=document.getElementById("CSNY");	//出生日期
	if (CSNYobj){CSNYobj.onkeydown=getage}
	FYIDobj=document.getElementById("FYID");	//费用性质代码
	if (FYIDobj){
		FYIDobj.size=1; 
		FYIDobj.multiple=false;
		AddListBox(FYIDobj,"FYQB","");
	}
	
	FFXZIDobj=document.getElementById("FFXZID");	//付费性质代码
	if (FFXZIDobj){
		FFXZIDobj.size=1; 
		FFXZIDobj.multiple=false;
		AddListBox(FFXZIDobj,"FYLB","");
	}
	RZIDobj=document.getElementById("RZID");	//职退情况
	if (RZIDobj){
		RZIDobj.size=1; 
		RZIDobj.multiple=false;
		AddListBox(RZIDobj,"RZID","");
	}
	JBIDobj=document.getElementById("JBID");	//职级代码
	if (JBIDobj){
		JBIDobj.size=1; 
		JBIDobj.multiple=false;
		AddListBox(JBIDobj,"JBID","");
	}
	BZNYobj=document.getElementById("BZNY");	//办证日期
	if (BZNYobj){BZNYobj.value=""}
	YYDHobj=document.getElementById("YYDH");	//选定医院代码
	if (YYDHobj){YYDHobj.value=""}
	DWDMobj=document.getElementById("DWDM");	//单位代码
	if (DWDMobj){DWDMobj.value=""}
	DWXZDMobj=document.getElementById("DWXZDM");	//单位性质
	if (DWXZDMobj){
		DWXZDMobj.size=1; 
		DWXZDMobj.multiple=false;
		AddListBox(DWXZDMobj,"DWXZDM","");
	}
	DWMCobj=document.getElementById("DWMC");	///单位名称
	if (DWMCobj){DWMCobj.value=""}
	DWDZobj=document.getElementById("DWDZ");	//单位地址
	if (DWDZobj){DWDZobj.value=""}
	DWDHobj=document.getElementById("DWDH");	//单位电话
	if (DWDHobj){DWDHobj.value=""}
	DWYBobj=document.getElementById("DWYB");	//单位邮编
	if (DWYBobj){DWYBobj.value=""}
	JTZZobj=document.getElementById("JTZZ");	//家庭地址
	if (JTZZobj){JTZZobj.value=""}
	ZZDHobj=document.getElementById("ZZDH");	//家庭电话
	if (ZZDHobj){ZZDHobj.value=""}
	ZZYBobj=document.getElementById("ZZYB");	//家庭邮编
	if (ZZYBobj){ZZYBobj.value=""}
	StaDateobj=document.getElementById("StaDate");	//生效日期(转院转诊的起始日期)
	if (StaDateobj){StaDateobj.value=""}
	EndDateobj=document.getElementById("EndDate");	//结束日期(转院转诊的终止日期)
	if (EndDateobj){EndDateobj.value=""}
	YearStrDateobj=document.getElementById("YearStrDate");	//年度开始时间
	if (YearStrDateobj){YearStrDateobj.value=""}
	MZQFDobj=document.getElementById("MZQFD");	//门诊起付段
	if (MZQFDobj){MZQFDobj.value=""}
	MZLJobj=document.getElementById("MZLJ");	//门诊欺负段累计
	if (MZLJobj){MZLJobj.value=""}
	ZYQFXobj=document.getElementById("ZYQFX");	//住院起付线
	if (ZYQFXobj){ZYQFXobj.value=""}
	NDLJobj=document.getElementById("NDLJ");	//年度累计
	if (NDLJobj){NDLJobj.value=""}
	ZYCSobj=document.getElementById("ZYCS");	//住院次数
	if (ZYCSobj){ZYCSobj.value=""}
	TZLXobj=document.getElementById("TZLX");	//转诊通知类型
	if (TZLXobj){
		TZLXobj.size=1; 
		TZLXobj.multiple=false;	
		TZLXobj.options[0]=new Option(t['TZLX0'],"0");
	  	TZLXobj.options[1]=new Option(t['TZLX1'],"1");
	  	TZLXobj.options[2]=new Option("","");
	}
	ZCYYDMobj=document.getElementById("ZCYYDM");	//转出医院代码
	if (ZCYYDMobj){ZCYYDMobj.value=""}
	ZCKSMCobj=document.getElementById("ZCKSMC");	//转出门诊科室名称
	if (ZCKSMCobj){ZCKSMCobj.value=""}
	ZCBQMCobj=document.getElementById("ZCBQMC");	//转出病区名称
	if (ZCBQMCobj){ZCBQMCobj.value=""}
	ZCCWBHobj=document.getElementById("ZCCWBH");	//转出床位编码
	if (ZCCWBHobj){ZCCWBHobj.value=""}
	ZRYYDHobj=document.getElementById("ZRYYDH");	//转入医院代码
	if (ZRYYDHobj){ZRYYDHobj.value=""}
	ZRKSMCobj=document.getElementById("ZRKSMC");	//门诊转入指定科室名称
	if (ZRKSMCobj){ZRKSMCobj.value=""}
	ZRBQMCobj=document.getElementById("ZRBQMC");	//门诊转入指定病区名称
	if (ZRBQMCobj){ZRBQMCobj.value=""}
}



function ClearAllList(obj) {
	if (obj.options.length>0) {
	for (var i=obj.options.length-1; i>=0; i--) obj.options[i] = null;
	}
}

function AddItemToList(obj,arytxt,aryval) {
	if (arytxt.length>0) {
		if (arytxt[0]!="") {
			var lstlen=obj.length;
			for (var i=0;i<arytxt.length;i++) {
				obj.options[lstlen] = new Option(arytxt[i],aryval[i]); lstlen++;}
		}
	}
}

function ListBoxSelected(ListBoxId)	{
	var row=false;
	for (var i=0;i<ListBoxId.length;i++) {
		if (ListBoxId.options[i].selected) {
			row=true;
			break;
		}
	}
	return row;
}
///为Listbox添加元素
///objlistbox
///ItemName元素名称这里用来取医保字典的类别
///TmpTariType区分医保类别(不同医保类型)公用传""否则传医保类别
function AddListBox(obj,ItemName,TmpTariType){
	
	ClearAllList(obj)
	var Ins=document.getElementById('QueryDicList');
  	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
 	var OutStr=cspRunServerMethod(encmeth,ItemName,TmpTariType);
 	if(OutStr==""){
		return;
	}
	var arytxt=new Array();
	var aryval=new Array();
	var valueAry=OutStr.split("!");
	if (valueAry.length>0) {
		var j=0
		for (var i=0;i<valueAry.length;i++) {			
			var arytmp=valueAry[j].split("^");
			arytxt[j]=arytmp[3];
			aryval[j]=arytmp[2];
			j++
		}	
	}
	if (obj) {
		AddItemToList(obj,arytxt,aryval)
	}
	
}
function Query_click(){
	var YLZBH="",Name="",AdmReason=""
	obj=document.getElementById('YLZBH');
	if (obj){YLZBH=obj.value}
		obj=document.getElementById('Name');
	if (obj){Name=obj.value}
			obj=document.getElementById('AdmReason');
	if (obj){AdmReason=obj.value}
	if ((YLZBH=="")&&(Name=="")){alert("保健号或者姓名不能同时为空！");return false}	 //AdmReason_"^"_YLZBH_"^"_Name_"^"_SFZH_"^"_FYID_"^"_FFXZID_"^"_DWDM
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCInsuLocInfo&YLZBH='+YLZBH+'&Name='+Name+'&AdmReason='+AdmReasonID;
    //window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=680,height=520,left=0,top=0')
    location.href=str
}
function Save(Instring){
	var tmpArr=Instring.split("^")
	var tmpbjh=tmpArr[2]
	var tmpinsuno=tmpArr[4]
	var tmppatid=tmpArr[6]
	var tmpzip=tmpArr[21]
	//Zhan 20121212 增加数据格式校验
	var fmtStr =/^[A-Za-z0-9]+$/;
	if((tmppatid.length!=15)&(tmppatid.length!=18)) { alert("数据非法!身份证号不完整!");return;}
	if(false==fmtStr.test(tmpbjh)) {alert("数据非法!保健号只能由数字或字母组成!");return;}
	if(false==fmtStr.test(tmpinsuno)) {alert("数据非法!社保卡号只能由数字或字母组成!"+tmpinsuno);return;}
	if(false==fmtStr.test(tmppatid)){ alert("数据非法!身份证号只能由数字或字母组成!");return;}
	if(""==AdmReasonobj.value){alert("维护类别不能为空!");return;}
	if((tmpzip.length!=6)||(isNaN(tmpzip))){alert("单位邮编只能是6位数字");return;}

	var Ins=document.getElementById('Save');
  	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
 	var OutStr=cspRunServerMethod(encmeth,Instring);
 	if(parseInt(OutStr)<=0){
		alert(t['Err02']);
		return;
	}
	else{alert("成功！");window.location.reload();}
}
function Savesli(Instring){
	var Ins=document.getElementById('Save');
  	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
 	var OutStr=cspRunServerMethod(encmeth,Instring);
 	if(parseInt(OutStr)<=0){
		alert(t['Err02']);
		return;
	}
}
function Delete(){
	//var Ins=document.getElementById('Save');
  	//if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
 	//var OutStr=cspRunServerMethod(encmeth,'','',Instring);
 	//if(parseInt(OutStr)<=0){
	//	alert(t['Err02']);
	//	return;
	//}
}
function Delete_click(){
	if (Rowidobj.value==""){
	alert("请选择要删除的记录!");
		return ;	
	}
	if (confirm(t['03']+Nameobj.value+t['04'])){
		var LocRow=Cstr(Rowidobj)


		var Ins=document.getElementById('Del');
  	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
  	
 	var OutStr=cspRunServerMethod(encmeth,LocRow);
	if(parseInt(OutStr)<0){
		alert(t['Err02']);
		return;
		}
		alert("删除成功")
		window.location.reload();
		}
	}	
function Update_click(){
	if (confirm(t['02']+Nameobj.value+t['04'])){
		if (YLZBHobj.value=="") {alert("保健号不能为空！");return;}
		if (Nameobj.value=="") {alert("姓名不能为空！");return;}
		if (AdmReasonID=="") {alert("维护类别 不能为空！");return;}
		if (AdmReasonobj.value!=tAdmReaDesc)
          {
	          alert("维护类别非法,请重新选择")
	          return ;
	      }
		 //验证数据是否有特殊字符DingSH 20171219
         var ChkValErrMsg=CheckInsuLocal()
         if (ChkValErrMsg.replace(/\r\n/g,"")!=""){
	         alert(ChkValErrMsg)
	         return ;
	         }
		 
		var Instring=Cstr(Rowidobj)+"^"+Cstr(XXLXobj)+"^"+Cstr(YLZBHobj)+"^"+Cstr(YLZZTobj)+"^"+Cstr(SBCARDobj)+"^"+Cstr(TXMobj)+"^"+Cstr(SFZHobj)
		Instring=Instring+"^"+Cstr(Nameobj)+"^"+Cstr(XBobj)+"^"+Cstr(CSNYobj)+"^"+Cstr(FYIDobj)+"^"+Cstr(FFXZIDobj)+"^"+Cstr(RZIDobj)
		Instring=Instring+"^"+Cstr(JBIDobj)+"^"+Cstr(BZNYobj)+"^"+Cstr(YYDHobj)+"^"+Cstr(DWDMobj)+"^"+Cstr(DWXZDMobj)+"^"+Cstr(DWMCobj)
		Instring=Instring+"^"+Cstr(DWDZobj)+"^"+Cstr(DWDHobj)+"^"+Cstr(DWYBobj)+"^"+Cstr(JTZZobj)+"^"+Cstr(ZZDHobj)+"^"+Cstr(ZZYBobj)+"^"+Cstr("")+"^"+Cstr("")
		Instring=Instring+"^"+Cstr(StaDateobj)+"^"+""+"^"+Cstr(EndDateobj)+"^"+""+"^"+Cstr(YearStrDateobj)+"^"+AdmReasonID+"^"+""+"^"+Cstr(MZQFDobj)+"^"+Cstr(MZLJobj)
		Instring=Instring+"^"+Cstr(ZYQFXobj)+"^"+Cstr(NDLJobj)+"^"+Cstr(ZYCSobj)+"^"+Cstr(TZLXobj)+"^"+Cstr(ZCYYDMobj)+"^"+Cstr(ZCKSMCobj)
		Instring=Instring+"^"+Cstr(ZCBQMCobj)+"^"+Cstr(ZCCWBHobj)+"^"+Cstr(ZRYYDHobj)+"^"+Cstr(ZRKSMCobj)+"^"+Cstr(ZRBQMCobj)
		//return;
		Save(Instring);
	}

}
function Add_click(){
		if (confirm(t['01']+Nameobj.value+t['04'])){
		Rowidobj.value=""
		
		
	
		
		//add 20101020
		if (YLZBHobj.value=="") {alert("保健号不能为空！");return;}
		if (Nameobj.value=="") {alert("姓名不能为空！");return;}
		if (AdmReasonID=="") {alert("维护类别 不能为空！");return;}
		if (AdmReasonobj.value!=tAdmReaDesc)
          {
	          alert("维护类别非法,请重新选择")
	          return ;
	      }
		var checkinfo=tkMakeServerCall("web.DHCINSULOCInfo","check",YLZBHobj.value)
		if(eval(checkinfo)>0){
			if(confirm('已有相同保健号的记录是否更新?')){
			}else{return;}
		}
		

        
         //验证数据是否有特殊字符DingSH 20171219
         var ChkValErrMsg=CheckInsuLocal()
         if (ChkValErrMsg.replace(/\r\n/g,"")!=""){
	         alert(ChkValErrMsg)
	         return ;
	         }
         
		var Instring=Cstr(Rowidobj)+"^"+Cstr(XXLXobj)+"^"+Cstr(YLZBHobj)+"^"+Cstr(YLZZTobj)+"^"+Cstr(SBCARDobj)+"^"+Cstr(TXMobj)+"^"+Cstr(SFZHobj)
		Instring=Instring+"^"+Cstr(Nameobj)+"^"+Cstr(XBobj)+"^"+Cstr(CSNYobj)+"^"+Cstr(FYIDobj)+"^"+Cstr(FFXZIDobj)+"^"+Cstr(RZIDobj)
		Instring=Instring+"^"+Cstr(JBIDobj)+"^"+Cstr(BZNYobj)+"^"+Cstr(YYDHobj)+"^"+Cstr(DWDMobj)+"^"+Cstr(DWXZDMobj)+"^"+Cstr(DWMCobj)
		Instring=Instring+"^"+Cstr(DWDZobj)+"^"+Cstr(DWDHobj)+"^"+Cstr(DWYBobj)+"^"+Cstr(JTZZobj)+"^"+Cstr(ZZDHobj)+"^"+Cstr(ZZYBobj)+"^"+Cstr("")+"^"+Cstr("")
		Instring=Instring+"^"+Cstr(StaDateobj)+"^"+""+"^"+Cstr(EndDateobj)+"^"+""+"^"+Cstr(YearStrDateobj)+"^"+AdmReasonID+"^"+""+"^"+Cstr(MZQFDobj)+"^"+Cstr(MZLJobj)
		Instring=Instring+"^"+Cstr(ZYQFXobj)+"^"+Cstr(NDLJobj)+"^"+Cstr(ZYCSobj)+"^"+Cstr(TZLXobj)+"^"+Cstr(ZCYYDMobj)+"^"+Cstr(ZCKSMCobj)
		Instring=Instring+"^"+Cstr(ZCBQMCobj)+"^"+Cstr(ZCCWBHobj)+"^"+Cstr(ZRYYDHobj)+"^"+Cstr(ZRKSMCobj)+"^"+Cstr(ZRBQMCobj)
		Save(Instring)
		}
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCInsuLocInfo');
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
     
    //alert(selectrow+"/"+iSeldRow)
    
	if (!selectrow) return;
	if (iSeldRow==selectrow){
		iSeldRow=""
		ItemsClear();
		return;
	}
	ItemsClear();
	iSeldRow=selectrow;
	var SelRowObj
	var obj
	SelRowObj=document.getElementById('TRowidz'+selectrow);
	if (SelRowObj){Rowidobj.value=SelRowObj.value}
	else{Rowidobj.value=""}
	//
	SelRowObj=document.getElementById('TXXLXz'+selectrow);
	if (SelRowObj){XXLXobj.value=SelRowObj.innerText}
	else{XXLXobj.value=""}
	SelRowObj=document.getElementById('TYLZBHz'+selectrow);
	if (SelRowObj){YLZBHobj.value=Trim(SelRowObj.innerText);}
	else{YLZBHobj.value=""}
	SelRowObj=document.getElementById('TYLZZTz'+selectrow);
	if (SelRowObj){YLZZTobj.value=Trim(SelRowObj.innerText)}
	else{YLZZTobj.value=""}	
	SelRowObj=document.getElementById('TSBCARDz'+selectrow);
	if (SelRowObj){SBCARDobj.value=Trim(SelRowObj.innerText);}
	else{SBCARDobj.value=""}	
	SelRowObj=document.getElementById('TTXMz'+selectrow);
	if (SelRowObj){TXMobj.value=Trim(SelRowObj.innerText)}
	else{TXMobj.value=""}		
	SelRowObj=document.getElementById('TSFZHz'+selectrow);
	if (SelRowObj){SFZHobj.value=Trim(SelRowObj.innerText)}
	else{SFZHobj.value=""}
	SelRowObj=document.getElementById('TNamez'+selectrow);
	if (SelRowObj){Nameobj.value=Trim(SelRowObj.innerText)}
	else{Nameobj.value=""}		
	SelRowObj=document.getElementById('TXBz'+selectrow);
	if (SelRowObj){XBobj.value=SelRowObj.innerText}
	else{XBobj.value=""}
	SelRowObj=document.getElementById('TCSNYz'+selectrow);
	if (SelRowObj){CSNYobj.value=Trim(SelRowObj.innerText)}
	else{CSNYobj.value=""}
	SelRowObj=document.getElementById('TFYIDz'+selectrow);
	if (SelRowObj){FYIDobj.value=SelRowObj.value}
	else{FYIDobj.value=""}
	SelRowObj=document.getElementById('TFFXZIDz'+selectrow);
	if (SelRowObj){FFXZIDobj.value=SelRowObj.value}
	else{FFXZIDobj.value=""}		
	SelRowObj=document.getElementById('TRZIDz'+selectrow);
	if (SelRowObj){RZIDobj.value=SelRowObj.value}
	else{RZIDobj.value=""}	
	

	
	SelRowObj=document.getElementById('TJBIDz'+selectrow);
	if (SelRowObj){JBIDobj.value=SelRowObj.value}
	else{JBIDobj.value=""}
	SelRowObj=document.getElementById('TBZNYz'+selectrow);
	if (SelRowObj){BZNYobj.value=Trim(SelRowObj.innerText)}
	else{BZNYobj.value=""}
	SelRowObj=document.getElementById('TYYDHz'+selectrow);
	if (SelRowObj){YYDHobj.value=Trim(SelRowObj.innerText)}
	else{YYDHobj.value=""}
	SelRowObj=document.getElementById('TDWDMz'+selectrow);
	if (SelRowObj){DWDMobj.value=Trim(SelRowObj.innerText)}
	else{DWDMobj.value=""}
	SelRowObj=document.getElementById('TDWXZDMz'+selectrow);
	if (SelRowObj){DWXZDMobj.value=SelRowObj.value}
	else{DWXZDMobj.value=""}
	SelRowObj=document.getElementById('TDWMCz'+selectrow);
	if (SelRowObj){DWMCobj.value=Trim(SelRowObj.innerText)}
	else{DWMCobj.value=""}
	SelRowObj=document.getElementById('TDWDZz'+selectrow);
	if (SelRowObj){DWDZobj.value=Trim(SelRowObj.innerText)}
	else{DWDZobj.value=""}
	SelRowObj=document.getElementById('TDWDHz'+selectrow);
	if (SelRowObj){DWDHobj.value=Trim(SelRowObj.innerText)}
	else{DWDZobj.value=""}
	SelRowObj=document.getElementById('TDWYBz'+selectrow);
	if (SelRowObj){DWYBobj.value=Trim(SelRowObj.innerText)}
	else{DWYBobj.value=""}
	SelRowObj=document.getElementById('TJTZZz'+selectrow);
	if (SelRowObj){JTZZobj.value=Trim(SelRowObj.innerText);}
	else{JTZZobj.value="";}
	SelRowObj=document.getElementById('TZZDHz'+selectrow);
	if (SelRowObj){ZZDHobj.value=Trim(SelRowObj.innerText)}
	else{ZZDHobj.value=""}
	SelRowObj=document.getElementById('TZZYBz'+selectrow);
	if (SelRowObj){ZZYBobj.value=Trim(SelRowObj.innerText)}
	else{ZZYBobj.value=""}
	SelRowObj=document.getElementById('TStaDatez'+selectrow);
	if (SelRowObj){StaDateobj.value=Trim(SelRowObj.innerText)}
	else{StaDateobj.value=""}
	SelRowObj=document.getElementById('TEndDatez'+selectrow);
	if (SelRowObj){EndDateobj.value=Trim(SelRowObj.innerText)}
	else{EndDateobj.value=""}
	SelRowObj=document.getElementById('TYearStrDatez'+selectrow);
	if (SelRowObj){YearStrDateobj.value=SelRowObj.innerText}
	else{YearStrDateobj.value=""}
	SelRowObj=document.getElementById('TMZLJz'+selectrow);
	if (SelRowObj){MZLJobj.value=SelRowObj.innerText}
	else{MZLJobj.value=""}
	
	
	
	/*SelRowObj=document.getElementById('TMZQFDz'+selectrow);
	if (SelRowObj){MZQFDobj.value=SelRowObj.innerText}
	else{MZQFDobj.value=""}

	SelRowObj=document.getElementById('TZYQFXz'+selectrow);
	if (SelRowObj){ZYQFXobj.value=SelRowObj.innerText}
	else{ZYQFXobj.value=""}
	SelRowObj=document.getElementById('TNDLJz'+selectrow);
	if (SelRowObj){NDLJobj.value=SelRowObj.innerText}
	else{NDLJobj.value=""}
	SelRowObj=document.getElementById('TZYCSz'+selectrow);
	if (SelRowObj){ZYCSobj.value=SelRowObj.innerText}
	else{ZYCSobj.value=""}*/
	SelRowObj=document.getElementById('TTZLXz'+selectrow);
	if (SelRowObj){TZLXobj.value=SelRowObj.innerText}
	else{TZLXobj.value=""}
	SelRowObj=document.getElementById('TZCYYDMz'+selectrow);
	if (SelRowObj){ZCYYDMobj.value=SelRowObj.innerText}
	else{ZCYYDMobj.value}
	SelRowObj=document.getElementById('TZCKSMCz'+selectrow);
	if (SelRowObj){ZCKSMCobj.value=SelRowObj.innerText}
	else{ZCKSMCobj.value=""}
	SelRowObj=document.getElementById('TZCBQMCz'+selectrow);
	if (SelRowObj){ZCBQMCobj.value=SelRowObj.innerText}
	else{ZCBQMCobj.value=""}
	SelRowObj=document.getElementById('TZCCWBHz'+selectrow);
	if (SelRowObj){ZCCWBHobj.value=SelRowObj.innerText}
	else{ZCCWBHobj.value=""}
	SelRowObj=document.getElementById('TZRYYDHz'+selectrow);
	if (SelRowObj){ZRYYDHobj.value=SelRowObj.innerText}
	else{ZRYYDHobj.value=""}
	SelRowObj=document.getElementById('TZRKSMCz'+selectrow);
	if (SelRowObj){ZRKSMCobj.value=SelRowObj.innerText}
	else{ZRKSMCobj.value=""}
	SelRowObj=document.getElementById('TZRBQMCz'+selectrow);
	if (SelRowObj){ZRBQMCobj.value=SelRowObj.innerText}
	else{ZRBQMCobj.value=""}
		SelRowObj=document.getElementById('TAdmReaDescz'+selectrow);
	if (SelRowObj){AdmReasonobj.value=SelRowObj.innerText;
	               tAdmReaDesc=SelRowObj.innerText;
	
	}
	else{AdmReasonobj.value=""}
			SelRowObj=document.getElementById('TAdmReasonz'+selectrow);
	if (SelRowObj){AdmReasonID=SelRowObj.value}
	else{AdmReasonID=""}
}	 
function Cstr(obj){
	OutStr=""
	if (obj==null){return OutStr }
	if (obj.value!=undefined){OutStr=obj.value}
	return OutStr
}
function InPut(FileName){
	    var xlApp,obook,osheet,xlsheet,xlBook,temp,str,vbdata,i,j 
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(FileName);
	    xlsheet = xlBook.ActiveSheet  
	    //var objtbl=parent.frames[0].document.getElementById('tINSUPRTFOOTSUM');
	    var i,j,k
	    ExcelRows=xlsheet.UsedRange.Cells.Rows.Count; 
		ExcelCols=xlsheet.UsedRange.Cells.Columns.Count;
		if (ExcelCols<24) {alert("请选择正确的名单文件!");return;}
        for (i=2;i<=ExcelRows;i++)
        {
	        var TmpList=new Array();
	        TmpList[0]=""
	        var InString=""
			for (j=1;j<=ExcelCols;j++){
				TmpList[j]=xlsheet.Cells(i,j).text
			}
			var Type=TmpList[33]
			var VerStr=tkMakeServerCall("web.DHCINSULOCInfo","GetLocInfoBySSID",TmpList[2],Type)
			var VerArr=VerStr.split("^")
			if (parseInt(VerArr[0])<=0){
				TmpList[0]=""
				for(;j<32;j++){TmpList[j]=""}
				TmpList[j]=Type
			}
			else{  ///是否还需要其他的判断
				if(TmpList[1]="1"){TmpList[0]=""}
				//VerArr[32]=Type
				TmpList[0]=VerArr[0]
				}
			
			for(k=1;k<TmpList.length;k++){
				InString=InString+"^"+TmpList[k]
				}
				
			for(;k<VerArr.length;k++){
				InString=InString+"^"+VerArr[k]
				}
			
				InString=TmpList[0]+InString
			//alert(InString)
			Savesli(InString)
			//return ;
	    }
	    alert("导入完成")
	    xlApp.Visible=false
	    xlBook.Close;
	    xlApp.Quit();
	    xlApp=null;
	    xlsheet=null   
}
 function getage()
 {	
 	if (window.event.keyCode==13) 
	{
		var p1=obj.value
		if (p1==""){
			alert(t['09']);
		return;
		}    
		getage1()
	}
 }
 function getage1(){
	 var p1=CSNYobj.value
     if (p1==""){
	     alert(t['09']);
	     return;
	 }else{
	 Birth_OnBlur(obj);
	 }
 }
 function Birth_OnBlur(obj){
	var mybirth=DHCWebD_GetObjValue("CSNY");
	if ((mybirth=="")||((mybirth.length!=8)&&((mybirth.length!=10)))){
		var obj=document.getElementById("CSNY");
		obj.className='clsInvalid';
		//websys_setfocus("birthdate");
		//return websys_cancel();
	}else{
		var obj=document.getElementById("CSNY");
		obj.className='clsvalid';
	}
	if ((mybirth.length==8)){
		var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(4,6)+"-"+mybirth.substring(6,8)
		DHCWebD_SetObjValueA("CSNY",mybirth);
	}
}
function DHCWebD_SetObjValueA(TName,transval){
	var Tobj=document.getElementById(TName);
	if(!Tobj){
		return;
	}
	switch (Tobj.type)
	{
		case "select-one":
			var myrows=Tobj.options.length;
			Tobj.options[myrows] = new Option(transval,"");	//,aryval[i]	
			break;
		case "checkbox":
			Tobj.checked=transval;	//txtobj.checked;
			break;
		case "text":
			Tobj.innerText=transval;		//txtobj.value;
			break;
		case "hidden":
			Tobj.value=transval;
			break;
		default:
			Tobj.innerText=transval;		//txtobj.value;
			break;
	}
}
function DHCWebD_GetObjValue(objname)
{
	var obj=document.getElementById(objname);
	var transval="";
	if (obj){
		switch (obj.type)
		{
			case "select-one":
				myidx=obj.selectedIndex;
				transval=obj.options[myidx].text;
				break;
			case "checkbox":
				transval=obj.checked;
				break;
			case "dhtmlXCombo":
				transval=obj.getSelectedValue();
				
				break;
			default:
				transval=obj.value;
				break;
		}
	}
	return transval;
}
function AdmReasonLookUp(value){
AdmReasonobj.value=value.split("^")[0]
AdmReasonID=value.split("^")[1]
tAdmReaDesc=value.split("^")[0]
}
// DingSH 20160409 
function Trim(value)
{
	return value.replace(/[ ]/g,"");
}

// DingSH 20160504 导入本地名单
function ImportBdInfo_onclick(){
	
	var fd = new ActiveXObject("MSComDlg.CommonDialog");
    fd.Filter = "*.xls"; //过滤文件类别
    fd.FilterIndex = 2;
    fd.MaxFileSize = 128;
    //fd.ShowSave();//如果是需要打开的话，就要用fd.ShowOpen();
    fd.ShowOpen();
    filePath=fd.filename;//fd.filename是用户的选择路径
    
    if(filePath=="")
    {
	    alert('请选择文件！')
	    return ;
    }
    
    var ErrMsg="";     //错误数据
    var errRowNums=0;  //错误行数
    var sucRowNums=0;  //导入成功的行数
    
	xlApp = new ActiveXObject("Excel.Application"); 
	xlBook = xlApp.Workbooks.open(filePath); 
	xlBook.worksheets(1).select(); 
    var xlsheet = xlBook.ActiveSheet;
    
    var rows=xlsheet.usedrange.rows.count;
    var columns=xlsheet.usedRange.columns.count;
    var i,j,k;
	try{

		for(i=2;i<=rows;i++){
			var pym="";
			
			var TmpList=new Array();
	        TmpList[0]=""
	        var InString=""
			for (j=1;j<=columns;j++){
				TmpList[j]=xlsheet.Cells(i,j).text
			}
			var Type=TmpList[33]
			var VerStr=tkMakeServerCall("web.DHCINSULOCInfo","GetLocInfoBySSID",TmpList[2],Type)
			var VerArr=VerStr.split("^")
			if (parseInt(VerArr[0])<=0){
				TmpList[0]=""
				for(;j<32;j++){TmpList[j]=""}
				TmpList[j]=Type
			}
			else{  
				if(TmpList[1]="1"){TmpList[0]=""}
				TmpList[0]=VerArr[0]
				}
			for(k=1;k<TmpList.length;k++){
				InString=InString+"^"+TmpList[k]
				}
				
			for(;k<VerArr.length;k++){
				InString=InString+"^"+VerArr[k]
				}
			
				InString=TmpList[0]+InString
		
		     var Ins=document.getElementById('Save');
          	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
 	        var savecode=cspRunServerMethod(encmeth,InString);
			if(savecode==null || savecode==undefined) savecode=-1
			if(eval(savecode)>=0){
				sucRowNums=sucRowNums+1;
		
			}else{
				errRowNums=errRowNums+1; 
				if(ErrMsg==""){
					ErrMsg=i;
				}else{
					ErrMsg=ErrMsg+"\t"+i;
				}
			}
		}
		
		if(ErrMsg==""){
			alert('数据正确导入完成')
		}else{
			var tmpErrMsg="成功导入【"+sucRowNums+"/"+(rows-1)+"】条数据";
			tmpErrMsg=tmpErrMsg+"失败数据行号如下：\n\n"+ErrMsg;
			alert(tmpErrMsg);   
		}
	}
	catch(e){
		alert("导入时发生异常：ErrInfo："+e.message);  
	}
	finally{
		xlBook.Close (savechanges=false);
		xlApp.Quit();
		xlApp=null;
		xlsheet=null;
	}
	
	}


//本地名单信息特殊字符校验	
function CheckInsuLocal()

{
	var ChkValErrMsg=""
	         var ErrMsg=CheckVal(Cstr(XXLXobj),"信息类型");
             ChkValErrMsg=ErrMsg;
                 
         var ErrMsg=CheckVal(Cstr(YLZBHobj),"保健号");
         if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
                 
         var ErrMsg=CheckVal(Cstr(YLZZTobj),"医疗证状态");
         if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
         
         var ErrMsg=CheckVal(Cstr(SBCARDobj),"社保卡号");
         if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
         
         
         var ErrMsg=CheckVal(Cstr(SFZHobj),"身份证号");
         if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
         
         
         var ErrMsg=CheckVal(Cstr(Nameobj),"病人姓名");
         if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
         
         var ErrMsg=CheckVal(Cstr(XBobj),"性别");
         if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
         var ErrMsg=CheckVal(Cstr(CSNYobj),"出生日期");
         if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
         
         var ErrMsg=CheckVal(Cstr(FYIDobj),"费用性质");
         if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
         
         var ErrMsg=CheckVal(Cstr(FFXZIDobj),"付费性质");
         if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
         
         var ErrMsg=CheckVal(Cstr(RZIDobj),"职退情况");
         if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
         
         var ErrMsg=CheckVal(Cstr(JBIDobj),"职级代码");
         if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
         
         var ErrMsg=CheckVal(Cstr(BZNYobj),"办证日期");
         if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
         
         var ErrMsg=CheckVal(Cstr(YYDHobj),"选定医院代码");
         if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
         
         var ErrMsg=CheckVal(Cstr(DWDMobj),"单位代码");
         if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
         
         var ErrMsg=CheckVal(Cstr(DWXZDMobj),"单位性质");
         if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
         
         var ErrMsg=CheckVal(Cstr(DWMCobj),"单位名称");
         if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
         
         var ErrMsg=CheckVal(Cstr(DWDZobj),"单位地址");
         if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
         
         var ErrMsg=CheckVal(Cstr(DWDHobj),"单位电话");
         if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
         
         var ErrMsg=CheckVal(Cstr(DWYBobj),"单位邮编");
         if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;

         var ErrMsg=CheckVal(Cstr(JTZZobj),"家庭地址");
         if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
         
         var ErrMsg=CheckVal(Cstr(ZZDHobj),"家庭电话");
         if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
         
         var ErrMsg=CheckVal(Cstr(ZZYBobj),"家庭邮编");
         if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
         
         var ErrMsg=CheckVal(Cstr(StaDateobj),"生效日期");
         if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
         
         var ErrMsg=CheckVal(Cstr(EndDateobj),"截止日期");
         if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
         
         var ErrMsg=CheckVal(Cstr(YearStrDateobj),"年度开始时间");
         if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
         
         var ErrMsg=CheckVal(Cstr(MZQFDobj),"门诊起付段");
         if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
         
         var ErrMsg=CheckVal(Cstr(MZLJobj),"门诊自负段累计");
         if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
         
         var ErrMsg=CheckVal(Cstr(ZYQFXobj),"住院起付线");
         if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
         
         var ErrMsg=CheckVal(Cstr(NDLJobj),"年度累计");
         if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
         
         var ErrMsg=CheckVal(Cstr(ZYCSobj),"住院次数");
         if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
         
         var ErrMsg=CheckVal(Cstr(TZLXobj),"转诊通知类型");
         if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
         
         var ErrMsg=CheckVal(Cstr(ZCYYDMobj),"转出医院代码");
         if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
         
         var ErrMsg=CheckVal(Cstr(ZCKSMCobj),"转出门诊科室名称");
         if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
         
         var ErrMsg=CheckVal(Cstr(ZCBQMCobj),"转出病区名称");
         if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
         
         var ErrMsg=CheckVal(Cstr(ZCCWBHobj),"转出床位编码");
         if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
         
         var ErrMsg=CheckVal(Cstr(ZRYYDHobj),"转入医院代码");
         if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
         
         var ErrMsg=CheckVal(Cstr(ZRBQMCobj),"转入指定病区名称");
         if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
	return ChkValErrMsg;
	
}	
	
//数据校验，校验是否特殊字符 DingSH 20171219
function CheckVal(InArgStr,InArgName)
{
	var ErrMsg="";
	var specialKey = "\^\'\""; 
	var isFlag=""
	//alert(specialKey)
	for (var i = 0; i < InArgStr.length; i++) {
      if(specialKey.indexOf(InArgStr.substr(i, 1))>=0)
      {
	      isFlag="1";
	   } 
    } 
    
    if (isFlag=="1") ErrMsg="【"+InArgName+"】"+"不允许有"+"\^" +"  "+"\'"+"  "+"\""+" 等字符" ;
    //alert(ErrMsg)
	return ErrMsg ;
	
}	
document.body.onload = BodyLoadHandler;
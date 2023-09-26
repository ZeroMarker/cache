var CurrentSel=0,TypeIndex,file
function BodyLoadHandler()
{
	//alert("11");
	var obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click;}
	var obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click;}
	var obj=document.getElementById("New");
	if (obj){ obj.onclick=New_click;}
	var obj=document.getElementById("Find");
	if (obj){ obj.onclick=Find_click;}
	var obj=document.getElementById("clear");
	if (obj){ obj.onclick=clear_click;}
	var obj=document.getElementById("PmpFlag");
	if (obj){ obj.onchange=OnChange;}
	var obj=document.getElementById("InPut");
	if (obj){ obj.onclick=InPut_click;}
	iniForm();	
	//PMPDictionary.CSP	
}
function GetType_OnChange()
{
	var myValue="";
	var obj=document.getElementById("PmpFlag");
	if (obj)
	{
		var myIdx=obj.options.selectedIndex;
		if(myIdx<0)
		{
			return;
		}
		myValue=obj.options[myIdx].value;
		var AdmTypeValobj=document.getElementById("PmpFlagId");
		AdmTypeValobj.value=myValue
	}
}
function SelectRowHandler()	
{
  var eSrc=window.event.srcElement;	
  var objtbl=document.getElementById('tPMP.Dictionary3');
  var rowObj=getRow(eSrc);
  var selectrow=rowObj.rowIndex;
  if (!selectrow) return;
  var SelRowObj
	var obj	
	if (selectrow==CurrentSel){		
        obj=document.getElementById("PmpCode");
        if (obj){obj.value=""}        
        obj=document.getElementById("PmpFlag");
        if (obj){obj.value=""}
        obj=document.getElementById("PmpFlagId");
        if (obj){obj.value=""}
        obj=document.getElementById("PmpRemark");
        if (obj){obj.value=""}
        obj=document.getElementById("PmpDesc");
        if (obj){obj.value=""}	
        obj=document.getElementById("PmpRowID");
        if (obj){obj.value=""}	
	    CurrentSel=0;
	    return;
	}		
  CurrentSel=selectrow;
  var row=selectrow;
  var DTYCode=document.getElementById('DTYCodez'+row);
  var DTYCodeValue=DTYCode.innerText;
  var DTYDesc=document.getElementById('DTYDescz'+row);
  var DTYDescValue=DTYDesc.innerText;
  var RowID=document.getElementById('RowIDz'+row);
  var RowIDValue=RowID.value;
  var DTYFlag=document.getElementById('DTYFlagz'+row);
  var DTYFlagValue=DTYFlag.innerText;
  var DTYRemark=document.getElementById('DTYRemarkz'+row);
  var DTYRemarkValue=DTYRemark.innerText;
  var obj=document.getElementById('PmpFlagId');
  obj.value=DTYFlagValue  
  var VerStr=tkMakeServerCall("web.PMP.PMPDictionary","CheckSelect",DTYFlagValue);
  var obj=document.getElementById('PmpFlag');
  for (var i=0;i<obj.options.length;i++){
		if (DTYFlagValue==obj.options[i].value){
		   obj.selectedIndex=i; 
		}
	}
  var obj=document.getElementById('PmpCode');
  obj.value=DTYCodeValue
  var obj=document.getElementById('PmpDesc');
  obj.value=DTYDescValue
  var obj=document.getElementById('PmpRemark');
  obj.value=DTYRemarkValue
  var obj=document.getElementById('PmpRowID');
  obj.innerText=RowIDValue
  var obj=document.getElementById('Deletez'+row);
  if (obj){ obj.onclick=Delete_click;}
}
function FrameEnterkeyCode()
{
	var e=window.event;
	switch (e.keyCode){
		//上下移动光标键
	case 38:
		var objtbl=window.document.getElementById('tPMP.Dictionary3');
		if (iSeldRow==1) {break;}
		var objrow=objtbl.rows[iSeldRow-1];
		objrow.click();
		break;
	case 40:
		var objtbl=window.document.getElementById('tPMP.Dictionary3');
		var rows=objtbl.rows.length-1;
		if (iSeldRow==rows) {break;}
		var objrow=objtbl.rows[iSeldRow+1];
		objrow.click();
		break;
	}
}
function OnChange()
{
	CurrentSel=0;
	Find_click();
	return;
	}
function InPut_click()
{
	//BrowseFolder()
	//alert("11")
	window.open('PMPDictionary.CSP	', '导入数据', 'resizable=yes,top=100,left=350');
	}
function iniForm()
{
	var obj=document.getElementById("PmpFlag");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		obj.onchange=GetType_OnChange;
		obj.options[0]=new Option("","");
		obj.options[1]=new Option("模块状态","Status");
		obj.options[2]=new Option("产品组","Product");
		obj.options[3]=new Option("职称","Profession");
		obj.options[4]=new Option("紧急程度","Emergency");
		obj.options[5]=new Option("需求状态","Improvement");
		obj.options[6]=new Option("需求类型","Type");
		obj.options[7]=new Option("严重程度","Degree");
		obj.options[8]=new Option("沟通方式","Communication");
		obj.options[9]=new Option("开发添加类型","AddDevDetail");
		 var xnhVal=document.getElementById("PmpFlagId")
		if(xnhVal.value!=""){
			setElementValue("PmpFlag",xnhVal.value);
		}
	}
	}
function Update_click()
{
	var obj=document.getElementById("PmpFlag");
	PmpFlagValue=obj.value
	var obj=document.getElementById("PmpCode");
	PmpCodeValue=obj.value
	if(PmpCodeValue==""){
		alert(t["10"])
		return;
		}
    var obj=document.getElementById("PmpDesc");
    PmpDescValue=obj.value
    if(PmpDescValue==""){
		alert(t["11"])
		return;
		}
    var obj=document.getElementById('PmpRemark');
    PmpRemarkValue=obj.value
    var obj=document.getElementById('PmpRowID');
    PmpRowIDValue=obj.value
    if(PmpRemarkValue==" "){PmpRemarkValue=""}
    var str=PmpFlagValue+"^"+PmpCodeValue+"^"+PmpDescValue+"^"+PmpRemarkValue+"^"+PmpRowIDValue+"^"+"Update"
    var VerStr=tkMakeServerCall("web.PMP.PMPDictionary","Update",str);
    alert(t[VerStr])
    //OpenWindow2()
    lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMP.Dictionary3&PmpFlagId="+PmpFlagValue;
	location.href=lnk;
	}
function Delete_click()
{
	var obj=document.getElementById("PmpFlag");
	PmpFlagValue=obj.value
	var obj=document.getElementById("PmpCode");
	PmpCodeValue=obj.value
	if(PmpCodeValue==""){
		alert(t["10"])
		return;
		}
    var obj=document.getElementById("PmpDesc");
    PmpDescValue=obj.value
    if(PmpDescValue==""){
		alert(t["11"])
		return;
		}
    var obj=document.getElementById('PmpRemark');
    PmpRemarkValue=obj.value
    var obj=document.getElementById('PmpRowID');
    PmpRowIDValue=obj.value
    if(PmpRemarkValue==" "){PmpRemarkValue=""}
    var str=PmpFlagValue+"^"+PmpCodeValue+"^"+PmpDescValue+"^"+PmpRemarkValue+"^"+PmpRowIDValue+"^"+"Delete"
    var VerStr=tkMakeServerCall("web.PMP.PMPDictionary","Update",str);
    alert(t[VerStr])
    lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMP.Dictionary3&PmpFlagId="+PmpFlagValue;
	location.href=lnk;
	}
function New_click()
{
	var obj=document.getElementById("PmpFlag");
	PmpFlagValue=obj.value
	if(PmpFlagValue==""){
		alert(t["12"])
		return;
		}
	var obj=document.getElementById("PmpCode");
	PmpCodeValue=obj.value
	if(PmpCodeValue==""){
		alert(t["10"])
		return;
		}
    var obj=document.getElementById("PmpDesc");
    PmpDescValue=obj.value
    if(PmpDescValue==""){
		alert(t["11"])
		return;
		}
    var obj=document.getElementById('PmpRemark');
    PmpRemarkValue=obj.value
    var obj=document.getElementById('PmpRowID');
    PmpRowIDValue=obj.value
    if(PmpRemarkValue==" "){PmpRemarkValue=""}
    var str=PmpFlagValue+"^"+PmpCodeValue+"^"+PmpDescValue+"^"+PmpRemarkValue+"^"+PmpRowIDValue+"^"+"Insert"
    var VerStr=tkMakeServerCall("web.PMP.PMPDictionary","Update",str);
    alert(t[VerStr])
    lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMP.Dictionary3&PmpFlagId="+PmpFlagValue;
	location.href=lnk;
	}
function Find_click()
{
	var obj=document.getElementById("PmpFlagId");
	if (obj)
	{
		var PmpFlagId=obj.value;
		var obj=document.getElementById('PmpFlag');
        for (var i=0;i<obj.options.length;i++){
		if (PmpFlagId==obj.options[i].value){
		   obj.selectedIndex=i; 
		}
	}
	}
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMP.Dictionary3&PmpFlagId="+PmpFlagId;
	location.href=lnk;
	}
function clear_click()
{
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMP.Dictionary3";
	location.href=lnk;
	}
function OpenWindow2() {
	 var url="copy C:\\Users\\Administrator\\Desktop\\项目管理.txt d:\\项目管理.txt"
	 Log(url);
	 //alert("ok")
	 s=new  ActiveXObject("WScript.Shell");     
     s.Run("d:\cmd.bat",0,true);
}
///JS生成bat文件
function Log(url){ 
	var fso=new	ActiveXObject("Scripting.FileSystemObject");
	var LogFolder="D:";
	if(!fso.FolderExists(LogFolder)){
		fso.CreateFolder(LogFolder);     	
	}
    ts=fso.OpenTextFile(LogFolder+"\\"+"cmd.bat",8,true);
	ts.WriteLine("@echo off");
    ts.WriteLine(url);
    ts.WriteLine("del d:\\cmd.bat");
	ts.Close();
}
function BrowseFolder() {
	 
	 var fd = new ActiveXObject("MSComDlg.CommonDialog");
       fd.Filter = "所有类型(*)"; //過濾文件類型
       fd.FilterIndex = 2;
       fd.MaxFileSize = 128;
       fd.ShowOpen();//打开对话框
       //fd.ShowSave();//保存对话框
       aa=fd.filename;//fd.filename路径
       alert(aa)
	/*
    try {
        var Message = "请选择文件！";  //选择框提示信息
        var Shell = new ActiveXObject("Shell.Application");
        //var Folder = Shell.BrowseForFolder(0, Message, 0x0040, 0x11); //起始目录为：我的电脑
        var Folder = Shell.BrowseForFolder(0,Message,0); //起始目录为：桌面
        if (Folder != null) {
            Folder = Folder.items();  // 返回 FolderItems 对象
            Folder = Folder.item();  // 返回 Folderitem 对象
            Folder = Folder.Path;   // 返回路径
            if (Folder.charAt(Folder.length - 1) != "\\") {
                Folder = Folder + "\\";
            }
            return Folder;
        }
    } catch (e) {
        alert(e.message);
    }
    */
}
document.body.onload = BodyLoadHandler;
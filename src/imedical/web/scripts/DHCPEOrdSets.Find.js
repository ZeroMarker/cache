/// DHCPEOrdSets.Find.js
/// by zhongricheng
var type="add"; // 类型，用于增加医嘱套，upd为修改
var index=0;

function BodyLoadHandler() {
	var obj;
	
	obj=document.getElementById("BAdd");
	if (obj) { obj.onclick=BAdd_click; }
	
	obj=document.getElementById("BDelete");
	if (obj) { obj.onclick=BDelete_click; }
	
	obj=document.getElementById("BUpdate");
	if (obj) { obj.onclick=BUpdate_click; }
	
	obj=document.getElementById("BSearch");
	if (obj) { obj.onclick=BSearch_click; }
	
	obj=document.getElementById("BClear");  // 清屏
	if (obj) { obj.onclick=BClear_click; }
	
	obj=document.getElementById("BDeitFlag"); // 是否有早餐
	if (obj) {obj.onclick=BDeitFlag_click;}

	obj=document.getElementById("BSelectLoc") // 科室维护
	if(obj) {obj.onclick=BSelectLoc_click}  
}

function BAdd_click(){
	//alert("Add");
	var Desc="",Alias="",Conditiones="",ARCOSEffDateFrom="",obj,ret;
	var UserID=session['LOGON.USERID']
	var UserCode=session["LOGON.USERCODE"];
	var	CTLOCID=session['LOGON.CTLOCID'];
	//var ARCOSCatID=12;  // 医嘱套ID OEC_OrderCategory
	var ARCOSCatID=tkMakeServerCall("web.DHCPE.OrderSets","GetARCItemCatID","").split("^")[2];  // 医嘱套ID OEC_OrderCategory
	obj=document.getElementById("Desc");
	if (obj.value.replace(/(^\s*)|(\s*$)/g,'')!="") { ARCOSDesc=obj.value; }
	else {alert("医嘱套描述不能为空！"); return false; }
	
	obj=document.getElementById("Alias");
	if (obj.value.replace(/(^\s*)|(\s*$)/g,'')!="") { ARCOSAlias=obj.value; }
	else { alert("医嘱套别名不能为空！"); return false; }
	
	obj=document.getElementById("Conditiones");
	if (obj.value.replace(/(^\s*)|(\s*$)/g,'')!="") { Conditiones=obj.value; }
	else { alert("条件不能为空！"); return false; }
	
	var ARCOSCode=getnum(7);
	obj=document.getElementById("Code");
	if (obj) {
				
		// 获取已选择的套餐等级的套餐代码
		var VipListObj = document.getElementsByName("OrdSetsVIPList");
		if(VipListObj) {
			var VipListLen=VipListObj.length; 
        	var PreCode="";
			for(var i=0;i<VipListLen;i++){  
            	if(VipListObj[i].checked == true){  
               		PreCode+=VipListObj[i].value;  
            	}   
        	}   
        	//alert("AddCode:"+PreCode);
        	PreCode=PreCode.replace(/\s+/g,"");
        	if (PreCode=="") { PreCode=tkMakeServerCall("web.DHCPE.OrderSets","GetDefVIP",0); }
		}
		
		// 按等级加前缀 默认等级为 普通 1  且M对大小写敏感
		ARCOSCode=PreCode+ARCOSCode;
       
		obj.value=ARCOSCode;
	}
	
	obj=document.getElementById("subCategory");
	if (obj.value!="") { subCatID=obj.value; }
	
	//医嘱套的名字要加上Code
	if (ARCOSDesc.indexOf("-")<0){
		ARCOSDesc=UserCode+"-"+ARCOSDesc;
	}
	//alert("ARCOSDesc:"+ARCOSCode)
	//取组
	var DocMedUnit=tkMakeServerCall("web.DHCUserFavItems","GetMedUnit",UserID,CTLOCID);
	var FavDepList="";
	var InUser=UserID;
	
	//条件判断设置相关值
	if (Conditiones=="1"){ // 个人
		FavDepList="";DocMedUnit="";
	}else if (Conditiones=="2"){ // 科室
		InUser="";FavDepList=CTLOCID;DocMedUnit=""
		if (ARCOSCode=='') {
			alert("请填写医嘱套代码!");
			return;
		}
	}else if(Conditiones=="3"){ // 全院
		InUser="";FavDepList="";DocMedUnit="";
		if (ARCOSCode=='') {
			alert("请填写医嘱套代码!");
			return;
		}
	}else if(Conditiones=="4"){
		FavDepList="";
		if (DocMedUnit==''){
			alert("您没有被加入到登陆科室有效的组内,不能进行该条件保存");
			return;
		}
	}
	obj=document.getElementById("ARCOSEffDateFrom");
	if (obj.value!="") { ARCOSEffDateFrom=obj.value; }
	else { ARCOSEffDateFrom=1 }
	if (type=="add"){
		//alert(InUser+","+ARCOSCode+","+ARCOSDesc+","+ARCOSCatID+","+subCatID+","+ARCOSEffDateFrom+","+ARCOSAlias+","+UserID+","+FavDepList+","+DocMedUnit+")");
		ret=tkMakeServerCall("web.DHCUserFavItems","InsertUserARCOS",InUser,ARCOSCode,ARCOSDesc,ARCOSCatID,subCatID,ARCOSEffDateFrom,ARCOSAlias,UserID,FavDepList,DocMedUnit)
		 // FavRowid_$C(1)_ARCOSRowid_$C(1)_ARCOSCode
		
		if (ret=='-1') {
			alert("保存医嘱套失败您可能填写了已经使用的代码!");
			return false;
		}
		var Arr=ret.split(String.fromCharCode(1))
		var ARCOSRowid=Arr[1];
		if(ARCOSRowid!=""){
		var flag=tkMakeServerCall("web.DHCPE.OrderSets","UpdateOrdSetsCode",ARCOSCode,ARCOSRowid);  
		}
		// 早餐维护，默认为N，不需要可注释，若默认为Y 入参则为 "Y^"+TempStr
		var TempStr = ret.split(String.fromCharCode(1))[1];
		// alert(TempStr); // ARCOSRowid
		tkMakeServerCall("web.DHCPE.OrderSets","OutOrdSetsDeitFlag","^"+TempStr);  
	}
	else if (type=="upd") {
		obj=document.getElementById("FavRowidz"+index);
		if (obj.value!="") { FavRowid=obj.value; }
		
		//alert(FavRowid+","+ARCOSCode+","+ARCOSDesc+","+ARCOSCatID+","+subCatID+","+ARCOSEffDateFrom+","+ARCOSAlias+","+FavDepList+","+DocMedUnit+","+UserID);
		ret=tkMakeServerCall("web.DHCUserFavItems","UpdateUserARCOS",FavRowid,ARCOSCode,ARCOSDesc,ARCOSCatID,subCatID,ARCOSEffDateFrom,ARCOSAlias,FavDepList,DocMedUnit,InUser);
		
		
		if (ret=='-1') {
			alert("更新失败!");
			return false;
		}
		else if(ret=='0') { alert("修改成功!");type="add"; }
	}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEOrdSets.Find&UserID="+UserID+"&subCatID="+subCatID;
	lnk=lnk+"&Conditiones="+Conditiones;
	location.href=lnk;
	
	lnk="websys.default.csp"
	parent.frames["OrdSets.List"].location.href=lnk;
	parent.frames["PreItemList.Qry2"].location.href=lnk;
	parent.frames["PreItemList.Qry3"].location.href=lnk;
}

function BDelete_click(){
	var UserID=session['LOGON.USERID'];
	var obj=document.getElementById("subCategory");
	if (obj.value!="") { subCatID=obj.value; }
	var obj=document.getElementById("Conditiones");
	if (obj.value.replace(/(^\s*)|(\s*$)/g,'')!="") { Conditiones=obj.value; }
	var CurRow = selectedRowObj.rowIndex;
	if(CurRow==0)
	{
		 alert("请选择医嘱套！");
		 return false; 
	}
	if (CurRow>0){
		if (!confirm("确定删除该套餐吗")) return false;
		var obj=document.getElementById("FavRowidz"+CurRow);
		if (obj.value!=""){
			var FavRowid=obj.value;
			//alert("FavRowid="+FavRowid)
			var ReturnValue=tkMakeServerCall("web.DHCUserFavItems","DeleteUserARCOS",FavRowid);
			if (ReturnValue=='-1') {
				alert("删除医嘱套失败.");  
			}else{
				alert("删除医嘱套成功.");  
				// 需要先清空查询条件
				BClear_click();
				
				var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEOrdSets.Find&UserID="+UserID+"&subCatID="+subCatID;
				lnk=lnk+"&Conditiones="+Conditiones;
				parent.frames["OrdSets.Edit"].location.href=lnk;
			}
		}
	}else{
		alert("请选择需要删除的医嘱套");
		return;
	}
}

function BUpdate_click(){
	var CurRow = selectedRowObj.rowIndex;
	try{
		if(CurRow>0){
			type="upd";
			index = CurRow;
			BAdd_click();
		}
		else{ alert("请选择医嘱套！");return false; }
	}
	catch(e){
		alert("修改失败！"+e.message);
	}
	finally{
		type="add";
	}
}

function BSearch_click(){
	var UserID=session['LOGON.USERID'];
	var Conditiones="",Code="",Desc="",Alias="",subCatID="",lnk="";
	
	var obj=document.getElementById("Conditiones");  // 条件
	if (obj.value!="") { Conditiones=obj.value; }
	
	var obj=document.getElementById("Code");  // 代码
	if (obj.value!="") { Code=obj.value.replace(/(^\s*)|(\s*$)/g,''); }
	
	var obj=document.getElementById("Desc");  // 名称
	if (obj.value!="") { Desc=obj.value.replace(/(^\s*)|(\s*$)/g,''); }
	
	var obj=document.getElementById("Alias");  // 别名
	if (obj.value!="") { Alias=obj.value.replace(/(^\s*)|(\s*$)/g,''); }
	
	var obj=document.getElementById("subCategory");  // 医嘱套子类
	if (obj.value!="") { subCatID=obj.value; }
	 
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEOrdSets.Find&UserID="+UserID+"&subCatID="+subCatID;
	lnk=lnk+"&Conditiones="+Conditiones+"&Code="+Code+"&Desc="+Desc+"&Alias="+Alias;

	location.href=lnk;
}

// 清屏
function BClear_click(){
	SetInputValueById("","Code");
	SetInputValueById("","Desc");
	SetInputValueById("","Alias");
	lnk="websys.default.csp"
	parent.frames["OrdSets.List"].location.href=lnk;
	parent.frames["PreItemList.Qry2"].location.href=lnk;
	parent.frames["PreItemList.Qry3"].location.href=lnk;
}

// 是否有早餐
function BDeitFlag_click(){
	var CurRow = selectedRowObj.rowIndex;
	var DeitFlag="",Instring="";
	
	if(CurRow>0){
		var obj=document.getElementById("DeitFlagz"+CurRow)
		if ("N"==obj.innerText) { DeitFlag="Y"; }
		else if ("Y"==obj.innerText) { DeitFlag="N"; }
	
		var id=document.getElementById("ARCOSRowidz"+CurRow);
		if(id) { Instring=DeitFlag+"^"+id.value; }
	
		var flag=tkMakeServerCall("web.DHCPE.OrderSets","OutOrdSetsDeitFlag",Instring); 
		if (flag==0) { BClear_click();location.reload(); }
	} else {
		alert("请选择医嘱套");
		return;
	}
}

// 科室维护
function BSelectLoc_click(){
	var CurRow = selectedRowObj.rowIndex;
	var rowid="";
	if(CurRow>0){
		var obj=document.getElementById("ARCOSRowidz"+CurRow);
		if (obj) var rowid=obj.value;
		var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEOrdSets.SelLoc&ARCOSRowId="+rowid;
		window.open(str,"_blank","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,top=200,left=300,width=550,height=700");
	} else {
		alert("请选择医嘱套");
		return;
	}
}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[0];
}

// 选中列表后 弹出选择套餐明细的界面 未选中时 执行清屏操作
function SelectRowHandler(){
	var ARCOSRowid="",lnk="";
	var CurRow = selectedRowObj.rowIndex;
	if(CurRow>0){
		SetInputValueById("ARCOSCodez"+CurRow,"Code");
		SetInputValueById("ARCOSDescz"+CurRow,"Desc");
		SetInputValueById("ARCOSAliasz"+CurRow,"Alias");
		
		// 套餐等级复选框 对应勾上
		var VipListObj = document.getElementsByName("OrdSetsVIPList");
		var VipListLen=VipListObj.length;
		if(VipListObj) {
			var obj=document.getElementById("tOrdSetsVIPIDz"+CurRow);
			if (obj.value!="") { 
				var val=obj.value;
				var VipId=val.split("^");
				var VipIdLen=VipId.length;
				for(var i=0;i<VipListLen;i++){
					for(var j=0;j<VipIdLen;j++){
						var ID = VipListObj[i].id.replace("VipId","");
						if(ID == VipId[j]){  
							VipListObj[i].checked=true;
							i = i + 1;
 						} else {
							VipListObj[i].checked=false;
						}
					}  
				}
			} else {
				for(var i=0;i<VipListLen;i++){	
					var ID = VipListObj[i].id.replace("VipId","");
					VipListObj[i].checked=false;	  
				}
			}
		} 
		
		var obj=document.getElementById("ARCOSRowidz"+CurRow);
		if (obj.value!="") { ARCOSRowid=obj.value; }
		
		// 每个医嘱套对应的科室
		var flag=tkMakeServerCall("web.DHCPE.SelectLoc","InfoOrd",ARCOSRowid);
		obj=document.getElementById("Loc");
		if (obj){ obj.value=flag; }
		
		lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEOrdSets.List&ARCOSRowid="+ARCOSRowid+"&QueryFlag=1";
		parent.frames["OrdSets.List"].location.href=lnk;
		// 项目选择界面
		lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.QryItm&TargetFrame=OrdSets.List&Type=Item";
		parent.frames["PreItemList.Qry2"].location.href=lnk;
		lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.QryItm&TargetFrame=OrdSets.List&Type=Lab";
		parent.frames["PreItemList.Qry3"].location.href=lnk;
	}
	else{
		BClear_click();
	}
	// alert(Code+Desc+Alias);
}

function SetInputValueById(TabinnerText,Inpvalue){
	var val="";
	if(TabinnerText!=""){
		var obj=document.getElementById(TabinnerText);
		if (obj.innerText!="") { var val=obj.innerText; }
	}
	var obj=document.getElementById(Inpvalue);
	if (obj) { obj.value=val; }
}

var jschars = ['0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'];
// 取随机值
function getnum(num){
	var str=""
	for(var i=0;i<num;i++){
		var id=Math.ceil(Math.random()*35);
		str+=jschars[id];
	}
	return str;
}

// 取当前日期在AddDayCount天后的日期
function GetDateStr(AddDayCount) { 
var dd = new Date(); 
	dd.setDate(dd.getDate()+AddDayCount);//获取AddDayCount天后的日期 
	var y = dd.getFullYear(); 
	var m = dd.getMonth()+1;//获取当前月份的日期 
	var d = dd.getDate(); 
	return y+"-"+m+"-"+d; 
} 

document.body.onload = BodyLoadHandler;
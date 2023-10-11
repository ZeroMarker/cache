/*
* FileName:	dhcinsu.taritemsextedit.js
* User:		DingSH 
* Date:		2023-02-17	
* Description: 医保目录扩展信息维护弹窗
*/
var GV = {
      UserId:session['LOGON.USERID'],
      HospId:"",
      HiType:"",
      InsuCode:"",
      InsuDesc:""
}
$.extend($.fn.validatebox.defaults.rules, {
	checkSelfPayProp: {    
	    validator: function(value) {
		    return (value >=0)&&(value<=1);
		},
		message: "自付比例只能>=0且<=1"
	}
});
$(function(){
	setPageLayout();    //设置页面布局
	setElementEvent();  //设置元素事件
	
});
//设置页面布局
function setPageLayout(){
   var flag =  InitGV();
   if (flag){
     InitHiTypeCmb();
     GetTaritemsExt();
   }
    
}
//初始化全局变量
function InitGV() {
    var Rq = INSUGetRequest();
    if(Rq){
        GV.HospId = Rq["HospId"];
        GV.HiType = Rq["HiType"];
        GV.InsuCode = Rq["InsuCode"];
        GV.InsuDesc = Rq["InsuDesc"];
         return true ;
    }
	return false;
}
//设置元素事件
function setElementEvent(){
    $("#btnU").click(function () {	
		SaveTaritemsExt();		
	});	 
	$("#btnC").click(function () {		
		websys_showModal('close');
	});
}

//根据编码等获取医保目录扩展信息 
function GetTaritemsExt(){
	$m({
		ClassName:"INSU.MI.BL.TarItemsExt",
		MethodName:"GetTarItemsExtByInsuCode",
		InsuCode:GV.InsuCode,
		InsuDesc:"",
		HospId:GV.HospId,
		HiType:GV.HiType,
		HiGrp:"",
		MedType:""
	},function(txtData){
		InitTaritemsExt(txtData);
	});
}
//初始化界面元素内容
function InitTaritemsExt(InData)
{
  //alert("InData"+InData)
  if (InData == ""){
	setValueById("ExtRowid","");
	setValueById("InsuCode",GV.InsuCode);
	setValueById("InsuDesc",GV.InsuDesc);
	setValueById("HiType",GV.HiType);
	return true;
  }
  var InDataArr =  InData.split("^")
   // 01-05：Rowid SPT 医保目录编码 SPT 医保目录名称 SPT 医保类型 SPT 特殊标志 SPT
   setValueById("ExtRowid",InDataArr[0]);
   setValueById("InsuCode",InDataArr[1]);
   setValueById("InsuDesc",InDataArr[2]);
   setValueById("HiType",InDataArr[3]);
   setValueById("SpFlag",InDataArr[4]);
  // 06-10：险种类型 SPT 医保人群 SPT 自付比例 SPT 医疗类别 SPT 限用条件说明 SPT
   setValueById("XzType",InDataArr[5]);
   setValueById("HiGrp",InDataArr[6]);
   setValueById("SelfPayProp",InDataArr[7]);
   setValueById("MedType",InDataArr[8]);
   setValueById("LmtCondDscr",InDataArr[9]);
  // 11-15：启用日期 SPT 有效期限 SPT 有效标志 SPT 创建人 SPT 创建日期 SPT 
   setValueById("BegnDate",InDataArr[10]);
   setValueById("EndDate",InDataArr[11]);
   setValueById("ValidFlag",InDataArr[12]);
   setValueById("CrterId",InDataArr[13]);
   setValueById("CrteDate",InDataArr[14]);
  //16-20：创建时间 SPT 更新人 SPT 更新日期 SPT 更新时间 SPT 医院ID SPT 创建人姓名 SPT更新人姓名
   setValueById("CrteTime",InDataArr[15]);
   setValueById("UpdtId",InDataArr[16]);
   setValueById("UpdtDate",InDataArr[17]);
   setValueById("UpdtTime",InDataArr[18]);
   setValueById("HospId",InDataArr[19]);
   setValueById("CrterName",InDataArr[20]);
   setValueById("UpdterName",InDataArr[21]);
   return true ;
}
//根据编码等获取医保目录扩展信息 
function SaveTaritemsExt(){
   var InStr = BulidTaritemsExt();
	$m({
		ClassName:"INSU.MI.BL.TarItemsExt",
		MethodName:"Save",
		InData:InStr
	},function(rtnData){
		if (+rtnData>0){
			$.messager.alert("温馨提示", "保存成功", 'success');
			setValueById("ExtRowid",+rtnData);
		}else{
			$.messager.alert("错误提示", "保存失败"+rtnData, 'error');
		}
	});
}
//组织医保目录扩展信息串
function BulidTaritemsExt(){
	
	 // 01-05：Rowid SPT 医保目录编码 SPT 医保目录名称 SPT 医保类型 SPT 特殊标志 SPT
     var InStr = getValueById("ExtRowid");
	 InStr=InStr+"^"+getValueById("InsuCode");
	 InStr=InStr+"^"+getValueById("InsuDesc");
	 InStr=InStr+"^"+getValueById("HiType");
	 InStr=InStr+"^"+getValueById("SpFlag");
    // 06-10：险种类型 SPT 医保人群 SPT 自付比例 SPT 医疗类别 SPT 限用条件说明 SPT
     InStr=InStr+"^"+getValueById("XzType");
     InStr=InStr+"^"+getValueById("HiGrp");
     InStr=InStr+"^"+getValueById("SelfPayProp");
     InStr=InStr+"^"+getValueById("MedType");
     InStr=InStr+"^"+getValueById("LmtCondDscr");
    // 11-16：启用日期 SPT 有效期限 SPT 有效标志 SPT 创建人 SPT 创建日期 SPT 创建时间 SPT 
     InStr=InStr+"^"+getValueById("BegnDate");
     InStr=InStr+"^"+getValueById("EndDate");
     InStr=InStr+"^"+getValueById("ValidFlag");
	 if (getValueById("ExtRowid")>0) {
      InStr=InStr+"^"+getValueById("CrterId");
      InStr=InStr+"^"+getValueById("CrteDate");
	  InStr=InStr+"^"+getValueById("CrteTime");
	 }else{
		InStr=InStr+"^"+GV.UserId+"^^";
	 }
    // 17-20：更新人 SPT 更新日期 SPT 更新时间 SPT 医院ID
	 if (getValueById("ExtRowid")>0){
		InStr=InStr+"^"+GV.UserId+"^^";
	 }else{
		InStr=InStr+"^^^"+"";
	 }
	 InStr=InStr+"^"+GV.HospId;
	 return InStr ;
}


//初始化医保类型
function InitHiTypeCmb() {
	$HUI.combobox("#HiType", {
		url: $URL,
		editable: false,
		valueField: 'cCode',
		textField: 'cDesc',
		panelHeight: 100,
		method: "GET",
		onBeforeLoad: function (param) {
			param.ClassName = "web.INSUDicDataCom"
			param.QueryName = "QueryDic"
			param.ResultSetType = "array";
			param.Type = "TariType"
			param.Code = ""
		},
		loadFilter: function (data) {
			for (var i in data) {
				if (data[i].cDesc == "全部") {
					data.splice(i, 1);
				}
			}
			return data;
		},
		onLoadSuccess: function (data) {
            setValueById('HiType',GV.HiType)
		}		 
	});
}
/**
* FillName: diageditcom.js
* Description: 医保诊断维护弹窗 
* Creator: HanZH
* Date: 2023-02-08
*/
//入口函数
var GV = {
	HospDr:session['LOGON.HOSPID'] ,  //院区ID
	USERID:session['LOGON.USERID'] ,  //操作员ID
	GROUPID:session['LOGON.GROUPID'], //安全组id
}
$.extend($.fn.validatebox.defaults.rules, {
	checkZfblMaxAmt: {    
	    validator: function(value) {
		    return (value >=0)&&(value<=1);
		},
		message: "输入值不能小于0大于1"
	}
});

GetjsonQueryUrl();

$(function(){
	initLayout();	//初始化面板
	initEvent();	//初始化事件
});

function initLayout(){
	clearDiag();
	var Rq = INSUGetRequest();
	var Rowid = Rq["Rowid"] ||"";
	var AllowUpdateFlag = Rq["AllowUpdateFlag"]; // 是否允许修改标志
	HospDr = Rq["HospId"];
	InitHiTypeCmb();	// 初始化医保类型
	InitHisVer();		// 初始化院内版本号
	GlobalInsuType=Rq["HiType"]; //
	$('#HiType').combobox('select',GlobalInsuType);		// 修改诊断医保类型传入
	if(Rowid!=""){
		disableById("HiType") ; //如果是新增则不禁用	在此处可根据情况添加 不允许医保办手动更改的  条目
	}else{
		$('#btnU').linkbutton({text:'新增',iconCls:'icon-w-add'});
	}
	if(AllowUpdateFlag == 'N'){
		$('#btnU').hide();//医保诊断对照界面链接过来的不允许修改	
	}
	$.m({
		ClassName: "web.INSUDiagnosis",
		MethodName: "GetDiagnosisById",
		type: "GET",
		RowId: Rowid
	},function (rtn) {
			if (rtn.split("^")[0] != "-1") {
				//alert("rtn="+rtn)
				var AryD = rtn.split("^");
				InsuType = AryD[1];
				loadDiagnosis(rtn); // 
			}
		});
	 disableById("Date");
	 disableById("Time");
	 disableById("UserDr");
	 disableById("ADDIP");
}
 
//初始化事件
function initEvent(){
	$("#btnU").click(function () {	
		SaveDiag();		//更新保存医保诊断
	});	 
	$("#btnC").click(function () {		
		websys_showModal('close');
	});
}

//初始化医保类型
function InitHiTypeCmb(){
	//初始化HiType
	// $HUI.combobox("#HiType", {
	// 	url: $URL,
	// 	editable: false,
	// 	valueField: 'cCode',
	// 	textField: 'cDesc',
	// 	panelHeight: 100,
	// 	method: "GET",
	// 	//data:comboJson.rows,
	// 	onBeforeLoad: function (param) {
	// 		param.ClassName = "web.INSUDicDataCom"
	// 		param.QueryName = "QueryDic1"
	//         param.Type = 'TariType';
	//         param.HospDr = PUBLIC_CONSTANT.SESSION.HOSPID  
	// 	},
	// 	loadFilter: function (data) {
	// 		for (var i in data) {
	// 			if (data[i].cDesc == "全部") {
	// 				data.splice(i, 1);
	// 			}
	// 		}
	// 		return data;
	// 	},
	// 	onLoadSuccess: function (data) {
	// 	},
	// 	onSelect: function (rec) {
	// 		// tangzf 2019-8-9 新增医保目录 切换医保类型时  加载combobox----------
	// 		// tangzf 2019-8-9 新增医保目录 切换医保类型时  加载combobox----------	 
	// 	}			 			 
	// });
	var diccombox=$('#HiType').combogrid({  
	    panelWidth:350,   
	    panelHeight:238,  
	    idField:'cCode',   
	    textField:'cDesc', 
        rownumbers:true,
        url:$URL,
        onBeforeLoad:function(param){
	        param.ClassName = 'web.INSUDicDataCom';
	        param.QueryName = 'QueryDic1';
	        param.Type = 'TariType';
	        param.HospDr = PUBLIC_CONSTANT.SESSION.HOSPID;    
	    },
        fit: true,
        pagination: false,
	    columns:[[   
	        {field:'cCode',title:'代码',width:60},  
	        {field:'cDesc',title:'描述',width:100}  
	    ]],
	    fitColumns: true,
	    onLoadSuccess:function(data){
		    diccombox.combogrid('setValue',data.rows[0].cCode);
		},
		onSelect:function(index,data){
			Initjcbzbz();	//初始化治疗方式
		}
	}); 
}

//初始化版本
function InitHisVer(){
	$('#HisVer').combobox({
		valueField: 'VersionCode',
		textField: 'VersionName',
		url:$URL,
		mode:'remote',
		onBeforeLoad:function(param){
			console.log(param)
			param.ClassName = 'web.DHCINSUPortUse';
			param.QueryName = 'GetBDVersionDic';
			param.rowid = '';
			param.code = '';
			param.desc = '';
			param.type='User.MRCICDDx';
			param.IsInsuFlag='Y';
			param.ResultSetType = 'array';
			return true;
		},
		onSelect: function (data) {
			Query();
		}
	});	
	
}

//初始化治疗方式
function Initjcbzbz(){
	var jcbzbzcombox=$('#jcbzbz').combogrid({  
	    panelWidth:350,   
	    panelHeight:238,  
	    idField:'cCode',   
	    textField:'cDesc', 
        rownumbers:true,
        url:$URL,
        onBeforeLoad:function(param){
	        param.ClassName = 'web.INSUDicDataCom';
	        param.QueryName = 'QueryDic1';
	        param.Type = 'trt_type'+$('#HiType').combogrid("getValue");
	        param.HospDr = PUBLIC_CONSTANT.SESSION.HOSPID;    
	    },
        fit: true,
        pagination: false,
	    columns:[[   
	        {field:'cCode',title:'代码',width:60},  
	        {field:'cDesc',title:'描述',width:100}  
	    ]],
	    fitColumns: true,
	    onLoadSuccess:function(data){
		    //jcbzbzcombox.combogrid('setValue',data.rows[0].cCode);
		},
		onSelect:function(index,data){
		}
		
	}); 
}

//医保诊断维护弹窗赋值
function loadDiagnosis(InData) {
	var AryD = InData.split("^");
	setTimeout(function () {
			setValueById("Rowid", AryD[0]);             //01  Rowid
			setValueById("HiType", AryD[1]);            //02 医保类型
			setValueById("bzbm", AryD[2]);     			//03 诊断代码
		}, 300);
	setValueById("bzmc", AryD[3]);                   	//04 诊断名称 
	setValueById("srrj", AryD[4]);                      //05 检索码 
	setValueById("srrj2", AryD[5]);                		//06 检索码2
	setValueById("jcbzbz", AryD[6]);                	//07 治疗方式
	setValueById("Cate", AryD[7]);                  	//08 病种类型
	setValueById("SubCate", AryD[8]);                   //09 病种子类型
	setValueById("Date", AryD[9]);                   	//10 更新日期
	setValueById("Time", AryD[10]);                  	//11 更新时间
	setValueById("UserDr", AryD[11]);                   //12 操作员
	setValueById("ADDIP", AryD[12]);                    //13 操作IP
	setValueById("ActiveDate", AryD[13]);               //14 生效日期                   
	setValueById("Unique", AryD[14]);            		//15 中心唯一码
	setValueById("INDISXString01", AryD[15]);           //16 预留串1
	setValueById("INDISXString02", AryD[16]);           //17 预留串2
	setValueById("INDISXString03", AryD[17]);           //18 预留串3
	setValueById("INDISXString04", AryD[18]);           //19 预留串4
	setValueById("INDISXString05", AryD[19]);           //20 预留串5
	setValueById("INDISXString06", AryD[20]);           //21 预留串6
	setValueById("INDISXString07", AryD[21]);           //22 预留串7
	setValueById("INDISXString08", AryD[22]);           //23 预留串8
	setValueById("HisVer", AryD[23]);                   //24 院内版本号
	setValueById("ExpiryDate", AryD[24]);          		//25 失效日期
	setValueById("HospId", AryD[25]);                   //26 院区指针
}	

//更新保存医保诊断
function SaveDiag(){
	var InStr = BuildDiagsStr();
	var savecode=tkMakeServerCall("web.INSUDiagnosis","SaveDiag",InStr)
	// if (savecode>0){
	// 	$.messager.alert('提示','保存医保诊断成功');
	// }
	// else{
	// 	$.messager.alert("提示","保存医保诊断失败!rtn="+savecode, 'error');	
	// }
	var rtnArr = savecode.split("!");
	
	if (rtnArr[0]>0){
		if(rtnArr.length>1){
			$.messager.alert('提示',"Rowid="+rtnArr);
		}
		else{
			$.messager.alert('提示','保存医保诊断成功');
		}
	}
	else{
		$.messager.alert("提示","保存医保诊断失败!rtn="+savecode, 'error');	
	}
}

//组织更新保存诊断信息串
function BuildDiagsStr() {
	var ADDIP = GetLocalIPAddress();
	//+20230214 HanZH	医保类型不能为空
	var HiType=$('#HiType').combogrid("getValue");
	if(HiType==""){
		$.messager.alert('提示','医保类型不能为空','info');
		return "-1";	
	}
	//+20230209 HanZH	院内版本号不能为空
	var HisVer=getValueById("HisVer");
	if(HisVer==""){
		$.messager.alert('提示','院内版本号不能为空','info');
		return "-1";	
	}

	var InStr = getValueById("Rowid");							//01  Rowid
	InStr = InStr + "^" + HiType;								//02 医保类型
	InStr = InStr + "^" + getValueById("bzbm");					//03 诊断代码
	InStr = InStr + "^" + getValueById("bzmc");					//04 诊断名称
	InStr = InStr + "^" + getValueById("srrj");					//05 检索码 
	InStr = InStr + "^" + getValueById("srrj2");                //06 检索码2
	InStr = InStr + "^" + getValueById("jcbzbz");               //07 治疗方式
	InStr = InStr + "^" + getValueById("Cate");                 //08 病种类型
	InStr = InStr + "^" + getValueById("SubCate");              //09 病种子类型
	InStr = InStr + "^" + ""; 					                //10 更新日期
	InStr = InStr + "^" + "";			   				        //11 更新时间
	InStr = InStr + "^" + GV.USERID;           				    //12 操作员
	InStr = InStr + "^" + ADDIP;               	 				//13 操作IP                   
	InStr = InStr + "^" + getValueById("ActiveDate");           //14 生效日期
	InStr = InStr + "^" + getValueById("Unique");             	//15 中心唯一码
	InStr = InStr + "^" + getValueById("INDISXString01");       //16 预留串1
	InStr = InStr + "^" + getValueById("INDISXString02");       //17 预留串2
	InStr = InStr + "^" + getValueById("INDISXString03");       //18 预留串3
	InStr = InStr + "^" + getValueById("INDISXString04");       //19 预留串4
	InStr = InStr + "^" + getValueById("INDISXString05");       //20 预留串5
	InStr = InStr + "^" + getValueById("INDISXString06");       //21 预留串6
	InStr = InStr + "^" + getValueById("INDISXString07");       //22 预留串7
	InStr = InStr + "^" + getValueById("INDISXString08");       //23 预留串8
	InStr = InStr + "^" + HisVer;      					       	//24 院内版本号
	InStr = InStr + "^" + getValueById("ExpiryDate");      		//25 失效日期
	InStr = InStr + "^" + getValueById("HospId");               //26 院区指针

	return InStr;
}

function GetLocalIPAddress()  
{  
    var obj = null;  
    var rslt = "";  
    try  
    {  
		//-------Zhan 20190521-------->
		if("undefined" != typeof ClientIPAddress){
			rslt=ClientIPAddress		
		}
		if(rslt!=""){return rslt};
		//<---------------------------//
        obj = new ActiveXObject("rcbdyctl.Setting");  
        rslt = obj.GetIPAddress;  
      	rslt=rslt.split(";")[0]
        obj = null;  
    }  
    catch(e)  
    {  
        //alert("异常，rcbdyctl.dll动态库未注册，请先注册!")
        rslt="";
    } 
    return rslt
}

//清空医保诊断维护
function clearDiag() {
	
	$("#Diag").form("clear");
	
}
 

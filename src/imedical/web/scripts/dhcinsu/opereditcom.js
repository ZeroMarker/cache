/*
* FileName:	opereditcom.js
* User:		Hanzh 
* Date:		2021-12-03	
* Description: 医保手术维护弹窗
*/
var GUser=session['LOGON.USERID'];
var HospDr='';
var GlobalInsuType = '';
$.extend($.fn.validatebox.defaults.rules, {
	checkZfblMaxAmt: {    
	    validator: function(value) {
		    return (value >=0)&&(value<=1);
		},
		message: "输入值不能小于0大于1"
	}
});

$(function () {
	initLayout();
	initEvent();
	init_HisVer();  // 版本 +20230115 HanZH
	
});		

function initLayout(){
	clearOperItm();
	var Rq = INSUGetRequest();
	var Rowid = Rq["Rowid"] ||"";
	
	var AllowUpdateFlag = Rq["AllowUpdateFlag"]; // 是否允许修改标志
	    HospDr = Rq["HospId"];
 	//// tangzf 2019-8-9 add new insuitmes start-----------------
	 InitHiTypeCmb(); // 初始化医保类型
	 GlobalInsuType=Rq["HiType"]; //
	 $('#HiType').combobox('select',GlobalInsuType);
	//disableById("HiType");
	InitUsedStd();	// 使用标记
	InitValiFlag();	// 有效标志
	if(Rowid!=""){
		disableById("HiType") ; //如果是新增则不禁用	在此处可根据情况添加 不允许医保办手动更改的  条目
	}else{
		$('#btnU').linkbutton({text:'新增',iconCls:'icon-w-add'});
	}
	if(AllowUpdateFlag == 'N'){
		$('#btnU').hide();//医保目录对照界面链接过来的不允许修改	
	}
	$.m({
		ClassName: "INSU.MI.DTO.OPRNOPRTLIST",
		MethodName: "GetOPRNOPRTLISTById",
		type: "GET",
		RowId: Rowid
	},function (rtn) {
			if (rtn.split("^")[0] != "-1") {
				//alert("rtn="+rtn)
				var AryD = rtn.split("^");
				InsuType = AryD[2];
				loadOperItm(rtn); // 
			}
		});
	// tangzf 2019-8-9 add new insuitmes end -----------------
	 disableById("HisCrterId");
	 disableById("HisCrteDate");
	 disableById("HisCrteTIme");
	 disableById("HisUpdtId");
	 disableById("HisUpdtDate");
	 disableById("HisUpdtTime");
	 disableById("HisBatch");
	 disableById("VerName");
	 disableById("Ver");
	 disableById("Rid");
	 disableById("OprnStdListId");
	 disableById("CrteTime");
	 disableById("UpdtTime");
}	
function initEvent(){
	$("#btnU").click(function () {	
		UpdateOperItm();		
	});	 
	$("#btnC").click(function () {		
		websys_showModal('close');
	});
	}		
//医保项目名称回车事件
/*$("#lxmmc").keyup(function(e) { lxmmc_onkeyup(e);});  

$('.textbox').blur(function (e){
	        try
	        {
			  INSUcheckText(this.value); 
	        }
	        catch(ex)
	        {
		        e.target.value="";
			    e.target.focus(); 
		     }
			
	});
});	
*/

//医保项目名称回车事件
/*
function lxmmc_onkeyup(e){	
	if (e.keyCode==13)
	{
	$.m({
		ClassName: "web.DHCINSUPort",
		MethodName: "GetCNCODE",
		type: "GET",
		HANZIS:getValueById("lxmmc"),
		FLAG: "4",
		SPLIT: ""
	},function (rtn)
	{	
		setValueById("lxmrj", rtn);	
		});
    }
    else{
	    if (getValueById("lxmmc")==""){setValueById("lxmrj", "")}
	    }
	
		
}*/
/*
 * 必填项检查
 */
function checkData() {
	var rtn = true;
	var inValiddatebox = $('.validatebox-invalid');
	if(inValiddatebox.length > 0){ //validdatebox
		rtn = false;
		$.messager.alert('提示', '数据验证失败' , 'error');
	}
	return rtn;
}
//初始化HiType
function InitHiTypeCmb() {
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
		}
		
	}); 
}

//加载使用标记
function InitUsedStd() {
	$HUI.combobox("#UsedStd", {
		editable: false,
		valueField: 'id', textField: 'text', panelHeight: "auto",
		data: [
			{ id: '1', text: '是' }
			, { id: '0', text: '否' }
	 
		]
	}
	);
}
//加载有效标志
function InitValiFlag() {
	$HUI.combobox("#ValiFlag", {
		editable: false,
		valueField: 'id', textField: 'text', panelHeight: "auto",
		data: [
			{ id: '1', text: '是' }
			, { id: '0', text: '否' }
		]
	}
	);
}
//医保手术维护弹窗赋值
function loadOperItm(InData) {
	var AryD = InData.split("^");
	setTimeout(function () {
			setValueById("Rowid", AryD[0]);             //01  Rowid
			setValueById("HospId", AryD[1]);            //02 医院ID
			setValueById("HiType", AryD[2]);            //03 医保类型
			setValueById("OprnStdListId", AryD[3]);     //04 手术标准目录ID
		}, 300);
	setValueById("Cpr", AryD[4]);                       //05 章 
	setValueById("CprCodeScp", AryD[5]);                //06 章代码范围
	setValueById("Cprname", AryD[6]);                  //07 章名称
	setValueById("CGyCode", AryD[7]);                  //08 类目代码
	setValueById("CgyName", AryD[8]);                   //09 类目名称
	setValueById("SorCode", AryD[9]);                  //10 亚目代码
	setValueById("SorName", AryD[10]);                  //11 亚目名称
	setValueById("DtlsCode", AryD[11]);                  //12 细目代码
	setValueById("DtlsName", AryD[12]);                 //13 细目名称                   
	setValueById("OprnOprtCode", AryD[13]);             //14 手术操作代码
	setValueById("OprnOprtName", AryD[14]);              //15 手术操作名称
	setValueById("UsedStd", AryD[15]);                  //16 使用标记
	setValueById("RtlOprnOprtCode", AryD[16]);          //17 团标版手术操作代码
	setValueById("RtlOprnOprtName", AryD[17]);          //18 团标版手术操作名称
	setValueById("ClncOprnOprtCode", AryD[18]);         //19 临床版手术操作代码
	setValueById("ClncOprnName", AryD[19]);             //20 临床版手术操作名称
	setValueById("Memo", AryD[20]);                      //21 备注
	setValueById("ValiFlag", AryD[21]);                 //22 有效标志
	setValueById("Rid", AryD[22]);                      //23 数据唯一记录号
	setValueById("CrteTime", AryD[23]);                 //24  数据创建时间
	setValueById("UpdtTime", AryD[24]);                 //25 数据更新时间
	setValueById("Ver", AryD[25]);                      //26 版本号
	setValueById("VerName", AryD[26]);                  //27 版本名称
	setValueById("HisBatch", AryD[27]);                 //28 HIS下载批次
	setValueById("HisCrterId", AryD[28]);               //29 HIS创建人
	setValueById("HisCrteDate", AryD[29]);              //30 HIS创建日期 
	setValueById("HisCrteTIme", AryD[30]);              //31 HIS创建时间
	setValueById("HisUpdtId", AryD[31]);                //32 HIS更新人ID
	setValueById("HisUpdtDate", AryD[32]);              //33 HIS更新日期
	setValueById("HisUpdtTime", AryD[33]);              //33 HIS更新时间
	setValueById("HisVer", AryD[34]);                 	//34 版本	+20230115 HanZH
	
}	
//更新医保手术
function UpdateOperItm() {
	var InStr = BuildOperItmFromEdStr();
	//if (InStr == "-1" || !checkData()) return "-1";
	if (InStr == "-1" ) return "-1";
	$.m({
		ClassName: "INSU.MI.DTO.OPRNOPRTLIST",
		MethodName: "CheckOPRNOPRTLIST",
		type: "GET",
		HospId: HospDr,
		HiType: GlobalInsuType,
		Code: getValueById('OprnOprtCode'),
		Desc: getValueById('OprnOprtName'),
		HisBatch: getValueById('HisBatch'),
		Ver: getValueById('Ver'),
		HisVer: getValueById('HisVer')
	}, function (rtn) {
		/*if ((rtn > 0) & ((rtn.split("^")).pop() != getValueById("Rowid"))) {
			$.messager.alert("提示", "有相同的手术项目,不允许保存", 'info');
			return "-1";
		}
		else {
			$.m({
				ClassName: "INSU.MI.DTO.OPRNOPRTLIST",
				MethodName: "SaveInsuOper",
				type: "GET",
				Instring: InStr
			}, function (srtn) {
				if (srtn == "0") { $.messager.alert("提示", "更新成功", 'info',function(){
					websys_showModal('close');	
				});}
				else { $.messager.alert("提示", "更新失败,Err=" + srtn, 'info');}
			});
		} */
		$.m({
			ClassName: "INSU.MI.DTO.OPRNOPRTLIST",
			MethodName: "SaveInsuOper",
			type: "GET",
			Instring: InStr
		}, function (srtn) {
			// if (srtn >"0") {$.messager.alert("提示", "更新成功,Rowid=" + srtn, 'info',function(){
			// 			websys_showModal('close');	
			// });}
			// else{ $.messager.alert("提示", "更新失败,Err=" + srtn, 'info');}
			var srtnArr = srtn.split("!");
			if (srtnArr[0] >"0") {
				if(srtnArr.length>1){
					$.messager.alert('提示',"Rowid="+srtnArr, 'info',function(){
						websys_showModal('close');	
					});
				}
				else{
					$.messager.alert("提示", "更新成功,Rowid=" + srtn, 'info',function(){
						websys_showModal('close');	
					});
				}
			}
			else { 
				$.messager.alert("提示", "更新失败,Err=" + srtn, 'info');	
			}
			
		});
	});		 
}

function BuildOperItmFromEdStr() {
	//+20230214 HanZH	医保类型不能为空
	if($('#HiType').combogrid("getValue")==""){
		$.messager.alert('提示','医保类型不能为空','info');
		return "-1";	
	}
	var UpdtUserId="",CrtUserId=GUser;
	if (getValueById("Rowid")>0){
		   UpdtUserId=GUser;
		   CrtUserId=""
		}
	var InStr = getValueById("Rowid");                              //01  Rowid
	InStr = InStr + "^" + HospDr;                                   //02 医院ID
	//InStr = InStr + "^" + getValueById("HiType");                 //03 医保类型
	InStr = InStr + "^" + $('#HiType').combogrid("getValue");       //03 医保类型
	InStr = InStr + "^" + getValueById("OprnStdListId");            //04 手术标准目录ID
	InStr = InStr + "^" + getValueById("Cpr");                      //05 章 
	InStr = InStr + "^" + getValueById("CprCodeScp");               //06 章代码范围
	InStr = InStr + "^" + getValueById("Cprname");                  //07 章名称
	InStr = InStr + "^" + getValueById("CGyCode");                  //08 类目代码
	InStr = InStr + "^" + getValueById("CgyName");                  //09 类目名称
	InStr = InStr + "^" + getValueById("SorCode");                  //10 亚目代码
	InStr = InStr + "^" + getValueById("SorName");                  //11 亚目名称
	InStr = InStr + "^" + getValueById("DtlsCode");                 //12 细目代码
	InStr = InStr + "^" + getValueById("DtlsName");                 //13 细目名称                   
	InStr = InStr + "^" + getValueById("OprnOprtCode");             //14 手术操作代码
	InStr = InStr + "^" + getValueById("OprnOprtName");             //15 手术操作名称
	InStr = InStr + "^" + getValueById("UsedStd");                  //16 使用标记
	InStr = InStr + "^" + getValueById("RtlOprnOprtCode");          //17 团标版手术操作代码
	InStr = InStr + "^" + getValueById("RtlOprnOprtName");          //18 团标版手术操作名称
	InStr = InStr + "^" + getValueById("ClncOprnOprtCode");         //19 临床版手术操作代码
	InStr = InStr + "^" + getValueById("ClncOprnName");             //20 临床版手术操作名称
	InStr = InStr + "^" + getValueById("Memo");                     //21 备注
	InStr = InStr + "^" + getValueById("ValiFlag");                 //22 有效标志
	InStr = InStr + "^" + getValueById("Rid");                      //23 数据唯一记录号
	InStr = InStr + "^" + getValueById("CrteTime");                 //24  数据创建时间
	InStr = InStr + "^" + getValueById("UpdtTime");                 //25 数据更新时间
	InStr = InStr + "^" + getValueById("Ver");                      //26 版本号
	InStr = InStr + "^" + getValueById("VerName");                  //27 版本名称
	InStr = InStr + "^" + getValueById("HisBatch");                 //28 HIS下载批次
	InStr = InStr + "^" + CrtUserId                                 //29 HIS创建人
	InStr = InStr + "^" + "";                                       //30 HIS创建日期 
	InStr = InStr + "^" + "";                                       //31 HIS创建时间
	InStr = InStr + "^" + UpdtUserId;                               //32 HIS更新人ID
	InStr = InStr + "^" +"";                                        //33 HIS更新日期
	InStr = InStr + "^" +"";                                        //34 HIS更新时间
	//+20230117 HanZH
	var HisVer=getValueById("HisVer");
	if(HisVer==""){
		$.messager.alert('提示','版本不能为空','info');
		return "-1";	
	}
	InStr = InStr + "^" + HisVer;                 					//35 版本
	return InStr;

}

//清空医保目录维护
function clearOperItm() {
	
	$("#InItmEPl").form("clear");
	
}	
/*
 *版本
 */
 function init_HisVer(){	
	//下拉列表
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
	      	param.type='User.ORCOperation';
	      	param.IsInsuFlag='Y';
	      	param.ResultSetType = 'array';
	      	return true;

		},
		onSelect: function (data) {		
		}
	});		
}


/*
* FileName:	dhcinsutareditcom.js
* User:		DingSH 
* Date:		2019-06-06	
* Description: 医保目录维护弹窗
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
	var Rq = INSUGetRequest();
	var rowid = Rq["InItmRowid"];
	var AllowUpdateFlag = Rq["AllowUpdateFlag"]; // 是否允许修改标志
	var HospDr = Rq["Hospital"]
	//// tangzf 2019-8-9 add new insuitmes start-----------------
	InitSfxmbmCmb(); // 初始化医保类型
	InitSfdlbm();	// 费用分类
	
	GlobalInsuType=Rq["INSUType"]; //
	$('#lsfxmbm').combobox('select',GlobalInsuType)
	disableById("lsfxmbm");
	Initflzb1();	// 分类指标1
	Initflzb2();	// 分类指标2
	//$('#lsfxmbm').combobox('reload');
	//init_lxmlbCombobox(); //项目类别
	if(rowid!=""){
		disableById("lsfxmbm") ; //如果是新增则不禁用	在此处可根据情况添加 不允许医保办手动更改的  条目
	}else{
		$('#btnU').linkbutton({text:'新增',iconCls:'icon-w-add'});
	}
	if(AllowUpdateFlag == 'N'){
		$('#btnU').hide();//医保目录对照界面链接过来的不允许修改	
	}
	// tangzf 2019-8-9 add new insuitmes end -----------------
	$.m({
		ClassName: "web.INSUTarItemsCom",
		MethodName: "GetInItemById",
		type: "GET",
		Rowid: rowid
	},function (rtn) {
			if (rtn != "-1") {
				//alert("rtn="+rtn)
				var AryD = rtn.split("^");
				InsuType = AryD[2];
				loadInItm(rtn); // 
			}
		});
	$("#btnU").click(function () {	
		UpdateInItm();		
	});	 
	$("#btnC").click(function () {		
		websys_showModal('close');
	});
	
	
	
//医保项目名称回车事件
$("#lxmmc").keyup(function(e) { lxmmc_onkeyup(e);});  

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


//医保项目名称回车事件
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
	
		
}
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
//初始化Sfxmbm
function InitSfxmbmCmb() {
	$HUI.combobox("#lsfxmbm", {
		url: $URL,
		editable: false,
		valueField: 'cCode',
		textField: 'cDesc',
		panelHeight: 100,
		method: "GET",
		//data:comboJson.rows,
		onBeforeLoad: function (param) {
			param.ClassName = "web.INSUDicDataCom"
			param.QueryName = "QueryDic"
			param.ResultSetType = "array";
			param.Type = "DLLType"
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
		},
		onSelect: function (rec) {
			// tangzf 2019-8-9 新增医保目录 切换医保类型时  加载combobox----------
			//var InsuType=rec.cCode;
			//INSULoadDicData('lsfdlbmdesc','FeeType' + GlobalInsuType);  // 加载费用分类
			//INSULoadDicData('ltjdm','AKA065' + GlobalInsuType);  // 加载项目等级
			//INSULoadDicData('lxmlb','AKE003' + GlobalInsuType);  // 加载项目类别
			INSULoadDicData('lsfdlbmdesc','med_chrgitm_type' + GlobalInsuType);  // 加载费用分类
			INSULoadDicData('ltjdm','chrgitm_lv' + GlobalInsuType);  // 加载项目等级
			INSULoadDicData('lxmlb','list_type' + GlobalInsuType);  // 加载项目类别
			// tangzf 2019-8-9 新增医保目录 切换医保类型时  加载combobox----------	 
		}			 			 
	});
}
function InitSfdlbm() {
	$("#lsfdlbmdesc").combobox({
		onSelect: function ( rowData,rowIndex) {
		 	setValueById("lsfdlbm", rowData.cCode);
		},
		onChange: function (newValue, oldValue) {
			if (!newValue) {
				setValueById("lsfdlbm", "");
			}
		}
	});
}	 
//加载医保有效标志flzb2
function Initflzb2() {
	$HUI.combobox("#lflzb2", {
		editable: false,
		valueField: 'id', textField: 'text', panelHeight: "auto",
		data: [
			{ id: 'Y', text: '是' }
			, { id: 'N', text: '否' }
	 
		]
	}
	);
}
//加载是否医保标志 flzb1
function Initflzb1() {
	$HUI.combobox("#lflzb1", {
		editable: false,
		valueField: 'id', textField: 'text', panelHeight: "auto",
		data: [
			{ id: 'Y', text: '是' }
			, { id: 'N', text: '否' }
		]
	}
	);
}
//医保目录维护弹窗赋值
function loadInItm(InData) {
	var AryD = InData.split("^");
	setTimeout(function () {
			setValueById("lrowid", AryD[0]);
			setValueById("lsfxmbm", AryD[2]);
			setValueById("lsfdlbm", AryD[1]);
			setValueById("lsfdlbmdesc", AryD[1]);
		}, 300);
	setValueById("lxmlb", AryD[7]);
	setValueById("lxmbm", AryD[3]);
	setValueById("lpzwh", AryD[14]);
	setValueById("lflzb3", AryD[26]);
	setValueById("lxmmc", AryD[4]);
	setValueById("lspmc", AryD[31]);
	setValueById("lflzb4", AryD[27]);
	setValueById("lgg", AryD[9]);
	setValueById("lspmcrj", AryD[32]);
	setValueById("lflzb5", AryD[28]);
	setValueById("ljx", AryD[8]);
	setValueById("lbzjg", AryD[15]);
	setValueById("lflzb6", AryD[29]);
	setValueById("ldw", AryD[10]);
	setValueById("lsjjg", AryD[16]);
	setValueById("lflzb7", AryD[30]);
	setValueById("lxmrj", AryD[5]);
	setValueById("lzgxj", AryD[17]);
	setValueById("lfplb", AryD[36]);
	setValueById("lyf", AryD[11]);
	setValueById("lbpxe", AryD[21]);
	setValueById("lljzfbz", AryD[33]);
	setValueById("lzfbl1", AryD[18]);
	setValueById("lyl", AryD[12]);
	setValueById("lyyjzjbz", AryD[34]);
	setValueById("lflzb1", AryD[24]);
	setValueById("lsl", AryD[13]);
	setValueById("lyysmbm", AryD[35]);
	setValueById("lzfbl2", AryD[19]);
	setValueById("lDicType", AryD[37]);
	setValueById("ltjdm", AryD[23]);
	setValueById("lzfbl3", AryD[20]);
	setValueById("lUnique", AryD[43]);
	setValueById("lActiveDate", AryD[42]);
	setValueById("ltxbz", AryD[6]);
	setValueById("lbz", AryD[22]);
	setValueById("lExpiryDate", AryD[44]);
	setValueById("lDate", AryD[39]);
	setValueById("lUserName", AryD[48]);
	setValueById("lUserDr", AryD[38]);	
	setValueById("lflzb2", AryD[25]);	// 2019-8-9 tangzf 有效标志
}	
//更新医保目录
function UpdateInItm() {
	var InStr = BuildInItmFromEdStr();
	if (InStr == "-1" || !checkData()) return "-1";
	$.m({
		ClassName: "web.INSUTarItemsCom",
		MethodName: "CheckInsu",
		type: "POST",
		InStr: InStr
	}, function (rtn) {
		if ((rtn > 0) & (rtn != getValueById("lrowid"))) {
			$.messager.alert("提示", "有相同的医保项目,不允许保存", 'info');
			return "-1";
		}
		else {
			$.m({
				ClassName: "web.INSUTarItemsCom",
				MethodName: "Update",
				type: "POST",
				itmjs: "",
				itmjsex: "",
				InString: InStr
			}, function (srtn) {
					if (srtn == "0") { $.messager.alert("提示", "更新成功", 'info',function(){
						websys_showModal('close');	
					});}
					else { $.messager.alert("提示", "更新失败,Err=" + srtn, 'info');}
				});
		} 
	});		 
}



function BuildInItmFromEdStr() {
	//*校验数据
	//var ChkValErrMsg = ChkValErr();			
	var InStr = getValueById("lrowid");
	InStr = InStr + "^" + getValueById("lsfdlbm")  //收费大类编码
	InStr = InStr + "^" + getValueById("lsfxmbm")  //医保类型
	InStr = InStr + "^" + getValueById("lxmbm")    //医保项目编码
	InStr = InStr + "^" + getValueById("lxmmc")    //医保项目名称
	InStr = InStr + "^" + getValueById("lxmrj")    //项目拼音码
	InStr = InStr + "^" + getValueById("ltxbz")    //限制用药标志
	InStr = InStr + "^" + getValueById("lxmlb")    //项目类别
	InStr = InStr + "^" + getValueById("ljx")      //剂型
	InStr = InStr + "^" + getValueById("lgg")      //规格
	InStr = InStr + "^" + getValueById("ldw")      //单位
	InStr = InStr + "^" + getValueById("lyf")      //用法
	InStr = InStr + "^" + getValueById("lyl")      //用量
	InStr = InStr + "^" + getValueById("lsl")      //数量
	InStr = InStr + "^" + getValueById("lpzwh")    //批准文号
	InStr = InStr + "^" + getValueById("lbzjg")    //标准价格
	InStr = InStr + "^" + getValueById("lsjjg")    //实际价格
	InStr = InStr + "^" + getValueById("lzgxj")    //最高限价
	InStr = InStr + "^" + getValueById("lzfbl1")   //自付比例1
	InStr = InStr + "^" + getValueById("lzfbl2")   //自付比例2
	InStr = InStr + "^" + getValueById("lzfbl3")   //自付比例3
	InStr = InStr + "^" + getValueById("lbpxe")    //报批限额
	InStr = InStr + "^" + getValueById("lbz")      //备注
	InStr = InStr + "^" + getValueById("ltjdm")    //项目等级
	InStr = InStr + "^" + getValueById("lflzb1")    //是否医保
	InStr = InStr + "^" + getValueById("lflzb2")    //有效标志 
	InStr = InStr + "^" + getValueById("lflzb3")    //分类指标3
	InStr = InStr + "^" + getValueById("lflzb4")    //分类指标4
	InStr = InStr + "^" + getValueById("lflzb5")    //分类指标5
	InStr = InStr + "^" + getValueById("lflzb6")    //分类指标6
	InStr = InStr + "^" + getValueById("lflzb7")    //分类指标7
	InStr = InStr + "^" + getValueById("lspmc")     //商品名称
	InStr = InStr + "^" + getValueById("lspmcrj")   //商品名称热键
	InStr = InStr + "^" + getValueById("lljzfbz")   //累计支付标志
	InStr = InStr + "^" + getValueById("lyyjzjbz")  //医院增加标志
	InStr = InStr + "^" + getValueById("lyysmbm")   //医院三目编码
	InStr = InStr + "^" + getValueById("lfplb")     //发票类别
	InStr = InStr + "^" + getValueById("lDicType")  //目录类别
	InStr = InStr + "^" + GUser + "^" + "" + "^" + "" + "^" + ClientIPAddress;
	InStr = InStr + "^" + getValueById("lActiveDate");
	InStr = InStr + "^" + getValueById("lUnique");
	InStr = InStr + "^" + getValueById("lExpiryDate");
	InStr = InStr + "^" + HospDr;
	return InStr;
}

//清空医保目录维护
function clearInItm() {
	setValueById("lrowid", "");
	setValueById("lsfxmbm", "");
	setValueById("lsfdlbmdesc", "");
	setValueById("lsfdlbm", "");
	setValueById("lxmlb", "");
	setValueById("lxmbm", "");
	setValueById("lpzwh", "");
	setValueById("lflzb3", "");
	setValueById("lxmmc", "");
	setValueById("lspmc", "");
	setValueById("lflzb4", "");
	setValueById("lgg", "");
	setValueById("lspmcrj", "");
	setValueById("lflzb5", "");
	setValueById("ljx", "");
	setValueById("lbzjg", "");
	setValueById("lflzb6", "");
	setValueById("ldw", "");
	setValueById("lsjjg", "");
	setValueById("lflzb7", "");
	setValueById("lxmrj", "");
	setValueById("lzgxj", "");
	setValueById("lfplb", "");
	setValueById("lyf", "");
	setValueById("lbpxe", "");
	setValueById("lljzfbz", "");
	setValueById("lzfbl1", "");
	setValueById("lyl", "");
	setValueById("lyyjzjbz", "");
	setValueById("lflzb1", "");
	setValueById("lsl", "");
	setValueById("lyysmbm", "");
	setValueById("lzfbl2", "");
	setValueById("lDicType", "");
	setValueById("ltjdm", "");
	setValueById("lzfbl3", "");
	setValueById("lUnique", "");
	setValueById("lActiveDate", "");
	setValueById("ltxbz", "");
	setValueById("lbz", "");
	setValueById("lExpiryDate", "");
	setValueById("lDate", "");
	setValueById("lUserName", "");
	setValueById("lUserDr", "");
}	
//数据校验，校验是否特殊字符 DingSH 20171219
function CheckVal(InArgStr, InArgName) {
	var ErrMsg = "";
	var specialKey = "\^\'\"\n";
	var isFlag = ""
	//alert(specialKey)
	for (var i = 0; i < InArgStr.length; i++) {
		if (specialKey.indexOf(InArgStr.substr(i, 1)) >= 0) {
			isFlag = "1";
		}
	} 
	if (isFlag == "1") ErrMsg = "【" + InArgName + "】" + "不允许有" + "\^" + "  " + "\'" + "  " + "\"" + " 回车 等字符";
	//alert(ErrMsg)
	return ErrMsg;
}	
function ChkValErr() {
	var ChkValErrMsg = CheckVal(getValueById("lsfdlbm"), "收费大类编码");
	var ErrMsg = CheckVal(getValueById("lsfxmbm"), "医保类型");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
			 
	var ErrMsg = CheckVal(getValueById("lxmbm"), "医保项目编码");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		 
	var ErrMsg = CheckVal(getValueById("lxmmc"), "医保项目名称");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		 
	var ErrMsg = CheckVal(getValueById("lxmrj"), "项目拼音码");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		
	var ErrMsg = CheckVal(getValueById("ltxbz"), "限制用药标志");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;

	var ErrMsg = CheckVal(getValueById("lxmlb"), "项目类别");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
 
	var ErrMsg = CheckVal(getValueById("ljx"), "剂型");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
			 
		 
	var ErrMsg = CheckVal(getValueById("lgg"), "规格");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
			 
	
	var ErrMsg = CheckVal(getValueById("ldw"), "单位");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		
	var ErrMsg = CheckVal(getValueById("lyf"), "用法");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		 
	var ErrMsg = CheckVal(getValueById("lyl"), "用量");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
	 
	var ErrMsg = CheckVal(getValueById("lsl"), "数量");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
	 
	var ErrMsg = CheckVal(getValueById("lpzwh"), "批准文号");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		 
	var ErrMsg = CheckVal(getValueById("lbzjg"), "标准价格");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
	
	var ErrMsg = CheckVal(getValueById("lsjjg"), "实际价格");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		
	var ErrMsg = CheckVal(getValueById("lzgxj"), "最高限价");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		 
	var ErrMsg = CheckVal(getValueById("lzfbl1"), "自付比例1");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
	
	var ErrMsg = CheckVal(getValueById("lzfbl2"), "自付比例2");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		 
	var ErrMsg = CheckVal(getValueById("lzfbl3"), "自付比例3");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		 
	var ErrMsg = CheckVal(getValueById("lbpxe"), "报批限额");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		 
	var ErrMsg = CheckVal(getValueById("lbz"), "备注");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
	
	var ErrMsg = CheckVal(getValueById("ltjdm"), "项目等级");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
	 
	var ErrMsg = CheckVal(getValueById("lflzb1"), "是否医保");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		
	var ErrMsg = CheckVal(getValueById("lflzb2"), "有效标志 ");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		 
	var ErrMsg = CheckVal(getValueById("lflzb3"), "分类指标3");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		 
	var ErrMsg = CheckVal(getValueById("lflzb4"), "分类指标4");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		 
	var ErrMsg = CheckVal(getValueById("lflzb5"), "分类指标5");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		 
	var ErrMsg = CheckVal(getValueById("lflzb6"), "分类指标6");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		
	var ErrMsg = CheckVal(getValueById("lflzb7"), "分类指标7");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		
	var ErrMsg = CheckVal(getValueById("lspmc"), "商品名称");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
	 
	var ErrMsg = CheckVal(getValueById("lspmcrj"), "商品名称热键");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		 
	var ErrMsg = CheckVal(getValueById("lljzfbz"), "累计支付标志");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
	 
	var ErrMsg = CheckVal(getValueById("lyyjzjbz"), "医院增加标志");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		 
	var ErrMsg = CheckVal(getValueById("lyysmbm"), "医院三目编码");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
 
 
	var ErrMsg = CheckVal(getValueById("lfplb"), "发票类别");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		

	var ErrMsg = CheckVal(getValueById("lActiveDate"), "有效日期");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		
	var ErrMsg = CheckVal(getValueById("lUnique"), "中心唯一码");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
		 
	var ErrMsg = CheckVal(getValueById("ExpiryDate"), "失效日期");
	if (ErrMsg != "") ChkValErrMsg = ChkValErrMsg + "\r\n" + ErrMsg;
	return ChkValErrMsg
}
/*
* 项目类别combobox lxmlb
* tangzf 2019-7-18
*/
// ???此处是写死 还是通过医保字典取?
function init_lxmlbCombobox() {
	/*$('#lxmlb').combobox({
		editable: false,
		valueField: 'id',
		textField: 'text',
		data: [
			{
				'id': '1',
				'text': '药品'
			},
			{
				'id': '2',
				'text': '诊疗'
			},
			{
				'id': '3',
				'text': '服务设施'
			}
		]
	})*/
}
 


 
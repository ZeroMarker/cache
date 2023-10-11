/**
 * common 公工组件库
 * 
 * Copyright (c) 2018-2019 LIYI. All rights reserved.
 * 
 * CREATED BY LIYI 2019-09-29
 * 
 * 注解说明
 * TABLE: 
 */

var CHR_1 = String.fromCharCode(1);
var CHR_2 = String.fromCharCode(2);
var CHR_3 = String.fromCharCode(3);
var CHR_4 = String.fromCharCode(4);
var CHR_5 = String.fromCharCode(5);
var CHR_6 = String.fromCharCode(6);
var CHR_7 = String.fromCharCode(7);
var CHR_8 = String.fromCharCode(8);

/**
 * 表单组件光标聚焦
 * @param {arguments[0]} 组件id
 * @return {void}
 */
function Common_Focus()
{
	if (typeof(arguments[0]) !== 'string') return '';
	if (arguments[0] == '') return '';
	var $this = $('#'+ arguments[0]);
	if ($this.length < 1) return '';
    var className = $this.attr("class").split(' ')[0];
    if (className == 'textbox') {  //文本框
	    $this.focus()
    }else if (className == 'hisui-numberbox') {  //数字
    	
    }else if (className == 'hisui-datebox') {  //日期
    	$this.next().children(":first").focus()
    }else if (className == 'hisui-timespinner') {  //时间框
    	$this.focus();
    }else if (className == 'hisui-combobox') {  //下拉框（多选下拉框没有封装）
   	   $this.next().children(":first").focus()
    }else if (className == 'hisui-switchbox') {  //开关
    	
    }else if (className == 'hisui-checkbox') {  // 单个复选框
    	
    }else if (className == 'hisui-radio') {  //单个单选框
    
    }else if (className == 'hisui-searchbox') {  //查询框框
    }
}

/**
 * 表单组件取值
 * @param {arguments[0]} 组件id
 * @return {itmValue} 表单
 */
function Common_GetValue()
{
	var itmValue = '';
	if (typeof(arguments[0]) !== 'string') return '';
	if (arguments[0] == '') return '';
	var $this = $('#'+ arguments[0]);
	if ($this.length < 1) return '';
    var className = $this.attr("class").split(' ')[0];
    if (className == 'textbox') {  //文本框
	    itmValue = $this.val();
    }else if (className == 'hisui-numberbox') {  //数字
    	itmValue = $this.val();	    
    }else if (className == 'hisui-datebox') {  //日期
    	itmValue = $this.datebox('getValue');	    
    }else if (className == 'hisui-timespinner') {  //时间框
    	itmValue = $this.timespinner('getValue');	
    }else if (className == 'hisui-combobox') {  //下拉框（多选下拉框没有封装）
   	  	itmValue = $this.combobox('getValue');
    }else if (className == 'hisui-switchbox') {  //开关
    	itmValue = $this.switchbox('getValue');	
    }else if (className == 'hisui-checkbox') {  // 单个复选框
    	itmValue = $this.checkbox('getValue');	    
    }else if (className == 'hisui-radio') {  //单个单选框
    	itmValue = $this.radio('getValue');
    }else if (className == 'hisui-searchbox') {  //查询框框
    	itmValue = $this.searchbox('getValue');	
    }
	return itmValue;	
}

/**
 * 多选字典取(label文字描述)
 * @param {arguments[0]} 组件id
 * @return {string} label文本
 */
function Common_CheckboxLabel() {
	var ItemCode = arguments[0];
    var value = "";
	$("input[name='"+ItemCode+"']:checked").each(function(){
	      value = value + $(this).attr("label")+ ","; 
	});
	if (value!="") { value = value.substring(0, value.length-1); }
	return value;
}

/**
 * 多选字典取值
 * @param {arguments[0]} 组件id
 * @return {string} 多选表单值
 */
function Common_CheckboxValue() {
	var ItemCode = arguments[0];
    var value = "";
	$("input[name='"+ItemCode+"']:checked").each(function(){
	      value = value + $(this).val()+ ","; 
	});
	if (value!="") { value = value.substring(0, value.length-1); }
	
	return value;
}

/**
 * 创建医院combobox
 * @param {arguments[0]} 组件id
 * @param {arguments[1]} 医院ID
 * @param {arguments[2]} 默认医院ID
 * @return {combobox} 院区combobox
 * @demo Common_ComboToHosp("cboHospital",'','')
 */
function Common_ComboToHosp(){
	var ItemCode = arguments[0];
	var aHospID = arguments[1];
	var tHospID	= arguments[2];
	if (typeof(ItemCode)=='undefined') ItemCode='';
	if (typeof(aHospID)=='undefined') aHospID='';
	if (typeof(tHospID)=='undefined') tHospID='';
	var cbox = $HUI.combobox("#"+ItemCode, {
		url: $URL,
		editable: false,
		defaultFilter:4,
		valueField: 'HospID',
		textField: 'HospDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'MA.IPMR.BTS.HospitalSrv';
			param.QueryName = 'QryHosp';
			param.aIsActive = '1';
			param.aHospId = aHospID;
			param.ResultSetType = 'array';
		},		
		onLoadSuccess:function(){
			var data=$(this).combobox('getData');
			if (data.length>0){
				for (i=0;i<data.length;i++){
					if (data[i]['HospID']==tHospID){
						$(this).combobox('select',data[i]['HospID']);
					}
				}
			}
		}
	});
	return  cbox;
}
/**
 * 创建病案类型combobox
 * @param {arguments[0]} 组件id
 * @param {arguments[1]} 病案分类代码
 * @return {combobox} 病案类型combobox
 * @demo Common_ComboToMrType("cboMrType","I")
 */
function Common_ComboToMrType(ItemCode,MrClass){
	var ItemCode = arguments[0];
	var MrClass	= arguments[1];
	if (typeof(ItemCode)=='undefined') ItemCode='';
	if (typeof(MrClass)=='undefined') MrClass='';
	var cbox = $HUI.combobox("#"+ItemCode, {
		url: $URL,
		editable: false,
		defaultFilter:4,
		valueField: 'ID',
		textField: 'MrTypeDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'CT.IPMR.BTS.MrTypeSrv';
			param.QueryName = 'QueryMrType';
			param.aMrClass = MrClass;
			param.ResultSetType = 'array';
		},		
		onLoadSuccess:function(){   //初始加载赋值
			var data=$(this).combobox('getData');
			if (data.length>0){
				$(this).combobox('select',data[0]['ID']);
			}
		}
	});
	return  cbox;
}
/**
 * 创建科室组combobox
 * @param {arguments[0]} 组件id
 * @param {arguments[1]} 科室组类型
 * @param {arguments[2]} 额外添加项目
 * @param {arguments[3]} 关键词
 * @return {combobox} 科室组combobox
 * @demo Common_ComboToLocGroup("cboLocgroup","E",Keyword)
 */
function Common_ComboToLocGroup(){
	var ItemCode= arguments[0];
	var Type	= arguments[1];
	var AddItem	= arguments[2];
	var Keyword	= arguments[3];
	if (typeof(ItemCode)=='undefined') ItemCode='';
	if (typeof(Type)=='undefined') Type='';
	if (typeof(AddItem)=='undefined') AddItem='';
	if (typeof(Keyword)=='undefined') Keyword='';
	var cbox = $HUI.combobox("#"+ItemCode, {
		url: $URL,
		editable: false,
		defaultFilter:4,
		valueField: 'ID',
		textField: 'Desc',
		onBeforeLoad: function (param) {
			param.ClassName = 'MA.IPMR.BTS.LocGroupSrv';
			param.QueryName = 'QueryLocGroup';
			param.aKeyword	= Keyword;
			param.aType		= Type;
			param.aAddItem	= AddItem;
			param.ResultSetType = 'array';
		}
	});
	return  cbox;
}

/**
 * 创建科室、病区combobox(多选）
 * @param {arguments[0]} 组件id
 * @param {arguments[1]} 关键字
 * @param {arguments[2]} 科室类型
 * @param {arguments[3]} 医院id
 * @param {arguments[4]} 就诊类型
 * @param {arguments[5]} 科室组id
 * @param {arguments[6]} 科室id
 * @return {combobox} 科室、病区 多选combobox
 * @demo Common_MultipleComboToLoc("cboLoc","内分泌","E",HospID,"I",LocGroup,LocID)
 */
function Common_MultipleComboToLoc(){
	var ItemCode= arguments[0];
	var Alias	= arguments[1];
	var LocType	= arguments[2];
	var HospId	= arguments[3];
	var AdmType = arguments[4];
	var LocGroup = arguments[5];
	var LocID	= arguments[6];
	if (typeof(ItemCode)=='undefined') ItemCode='';
	if (typeof(Alias)=='undefined') Alias='';
	if (typeof(LocType)=='undefined') LocType='';
	if (typeof(HospId)=='undefined') HospId='';
	if (typeof(AdmType)=='undefined') AdmType='';
	if (typeof(LocGroup)=='undefined') LocGroup='';
	if (typeof(LocID)=='undefined') LocID='';
	var cbox = $HUI.combobox("#"+ItemCode, {
		url: $URL,
		editable: true,
		defaultFilter:4,
		valueField: 'ID',
		textField: 'Desc',
		multiple:true,
		selectOnNavigation:false,
		rowStyle:'checkbox', //显示成勾选行形式
		onBeforeLoad: function (param) {
			param.ClassName = 'MA.IPMR.BTS.LocationSrv';
			param.QueryName = 'QryLoc';
			param.aHospId	= HospId;
			param.aLocType	= LocType;
			param.aAdmType	= AdmType;
			param.aLocGroup	= LocGroup;
			param.aKeyword	= Alias;
			param.aLocID	= LocID;
			param.ResultSetType = 'array';
		}
	});
	return  cbox;
}
/**
 * 创建科室、病区combobox
 * @param {arguments[0]} 组件id
 * @param {arguments[1]} 关键字
 * @param {arguments[2]} 科室类型
 * @param {arguments[3]} 医院id
 * @param {arguments[4]} 就诊类型
 * @param {arguments[5]} 科室组id
 * @param {arguments[6]} 科室id
 * @return {combobox} 科室、病区combobox
 * @demo Common_ComboToLoc("cboLoc","内分泌","E",HospID,"I",LocGroup,LocID)
 */
function Common_ComboToLoc(){
	var ItemCode= arguments[0];
	var Alias	= arguments[1];
	var LocType	= arguments[2];
	var HospId	= arguments[3];
	var AdmType = arguments[4];
	var LocGroup = arguments[5];
	var LocID	= arguments[6];
	var ID	= arguments[7];	// 指定某个ID
	if (typeof(ItemCode)=='undefined') ItemCode='';
	if (typeof(Alias)=='undefined') Alias='';
	if (typeof(LocType)=='undefined') LocType='';
	if (typeof(HospId)=='undefined') HospId='';
	if (typeof(AdmType)=='undefined') AdmType='';
	if (typeof(LocGroup)=='undefined') LocGroup='';
	if (typeof(LocID)=='undefined') LocID='';
	if (typeof(ID)=='undefined') ID='';
	var cbox = $HUI.combobox("#"+ItemCode, {
		url: $URL,
		editable: true,
		defaultFilter:4,
		valueField: 'ID',
		textField: 'Desc',
		onBeforeLoad: function (param) {
			param.ClassName = 'MA.IPMR.BTS.LocationSrv';
			param.QueryName = 'QryLoc';
			param.aHospId	= HospId;
			param.aLocType	= LocType;
			param.aAdmType	= AdmType;
			param.aLocGroup	= LocGroup;
			param.aKeyword	= Alias;
			param.aLocID	= LocID;
			param.aID	= ID;
			param.aIsActive	= 1;
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(){
			var data=$(this).combobox('getData');
			if (data.length==1){
				$(this).combobox('select',data[0]['ID']);
			}
		}
	});
	return  cbox;
}

/**
 * 创建工作流combobox
 * @param {arguments[0]} 组件id
 * @return {combobox} 工作流combobox
 * @demo Common_ComboToWorkFlow('WorkFlow')
 */
function Common_ComboToWorkFlow(){
	var ItemCode = arguments[0];
	if (typeof(ItemCode)=='undefined') ItemCode='';
	var cbox = $HUI.combobox("#"+ItemCode, {
		url: $URL,
		editable: false,
		defaultFilter:4,
		valueField: 'ID',
		textField: 'Desc',
		onBeforeLoad: function (param) {
			param.ClassName = 'CT.IPMR.BTS.WorkFlowSrv';
			param.QueryName = 'QryWorkFlow';
			param.ResultSetType = 'array';
		},		
		onLoadSuccess:function(data){
			if (data.length>0){
			}
		}
	});
	return  cbox;
}

/**
 * 创建工作流操作项目combobox
 * @param {arguments[0]} 组件id
 * @param {arguments[1]} 工作流id
 * @return {combobox} 工作流操作项目combobox
 * @demo Common_ComboToWorkFItem('WorkFlow')
 */
function Common_ComboToWorkFItem(){
	var ItemCode = arguments[0];
	var WorkFlowID= arguments[1];
	var Type= arguments[2];
	if (typeof(ItemCode)=='undefined') ItemCode='';
	if (typeof(WorkFlowID)=='undefined') WorkFlowID='';
	if (typeof(Type)=='undefined') Type='';
	var cbox = $HUI.combobox("#"+ItemCode, {
		url: $URL,
		editable: false,
		defaultFilter:4,
		valueField: 'WFItemID',
		textField: 'WFItemDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'CT.IPMR.BTS.WorkFItemSrv';
			param.QueryName = 'QryWFItem';
			param.aWorkFlowID = WorkFlowID;
			param.aType		= Type;
			param.ResultSetType = 'array';
		},		
		onLoadSuccess:function(data){
			if (data.length>0){
			}
		}
	});
	return  cbox;
}

/**
 * 创建基础字典combobox（字典代码为value）
 * @param {arguments[0]} 组件id
 * @param {arguments[1]} 字典类型代码
 * @param {arguments[2]} 有效标志
 * @param {arguments[3]} 医院id
 * @return {combobox} 基础字典combobox
 * @demo Common_ComboToDicCode("cboDic","SYS",1,HospID);
 */ 
function Common_ComboToDicCode(){
	var ItemCode = arguments[0];
	var DicType  = arguments[1];
	var IsActive = arguments[2];
	var HospID   = arguments[3];
	if (typeof(ItemCode)=='undefined') ItemCode='';
	if (typeof(DicType)=='undefined') DicType='';
	if (typeof(IsActive)=='undefined') IsActive='';
	if (typeof(HospID)=='undefined') HospID='';
	var cbox = $HUI.combobox("#"+ItemCode, {
		url: $URL,
		editable: true,
		defaultFilter:4,
		valueField: 'Code',
		textField: 'Desc',
		panelWidth:200,
		onBeforeLoad: function (param) {
			param.ClassName = 'CT.IPMR.BTS.DictionarySrv';
			param.QueryName = 'QryDictionary';
			param.aDicType   = DicType;
			param.aIsActive  = IsActive;
			param.aHospID    = HospID;
			param.ResultSetType = 'array';
		},		
		onLoadSuccess:function(data){
			if (data.length>0){}
		}
	});
	return  cbox;
}

/**
 * 创建基础字典combobox（字典ID为value）
 * @param {arguments[0]} 组件id
 * @param {arguments[1]} 字典类型代码
 * @param {arguments[2]} 有效标志
 * @param {arguments[3]} 医院id
 * @return {combobox} 基础字典combobox
 * @demo Common_ComboToDic("cboDic","SYS",1,HospID);
 */ 
function Common_ComboToDic(){
	var ItemCode = arguments[0];
	var DicType  = arguments[1];
	var IsActive = arguments[2];
	var HospID   = arguments[3];
	if (typeof(ItemCode)=='undefined') ItemCode='';
	if (typeof(DicType)=='undefined') DicType='';
	if (typeof(IsActive)=='undefined') IsActive='';
	if (typeof(HospID)=='undefined') HospID='';
	var cbox = $HUI.combobox("#"+ItemCode, {
		url: $URL,
		editable: true,
		defaultFilter:4,
		valueField: 'ID',
		textField: 'Desc',
		codeField:'Code',
		filter: function(q, row){
			var opts = $(this).combobox('options');
			return (row[opts.textField].indexOf(q) > -1)||(row[opts.codeField].indexOf(q) > -1);
		},
		selectOnNavigation:false,
		onBeforeLoad: function (param) {
			param.ClassName = 'CT.IPMR.BTS.DictionarySrv';
			param.QueryName = 'QryDictionary';
			param.aDicType   = DicType;
			param.aIsActive  = IsActive;
			param.aHospID    = HospID;
			param.ResultSetType = 'array';
		},		
		onLoadSuccess:function(data){
			if (data.length>0){}
		}
	});
	return  cbox;
}

/**
 * 创建基础字典多选combobox（字典代码为value）
 * @param {arguments[0]} 组件id
 * @param {arguments[1]} 字典类型代码
 * @param {arguments[2]} 有效标志
 * @param {arguments[3]} 医院id
 * @return {combobox} 基础字典多选combobox
 * @demo Common_MultipleComboToDicCode("cboDic","SYS",1,HospID);
 */ 
function Common_MultipleComboToDicCode(){
	var ItemCode = arguments[0];
	var DicType  = arguments[1];
	var IsActive = arguments[2];
	var HospID   = arguments[3];
	if (typeof(ItemCode)=='undefined') ItemCode='';
	if (typeof(DicType)=='undefined') DicType='';
	if (typeof(IsActive)=='undefined') IsActive='';
	if (typeof(HospID)=='undefined') HospID='';
	var cbox = $HUI.combobox("#"+ItemCode, {
		url: $URL,
		editable: true,
		defaultFilter:4,
		valueField: 'Code',
		textField: 'Desc',
		multiple:true,
		selectOnNavigation:false,
		rowStyle:'checkbox', //显示成勾选行形式
		onBeforeLoad: function (param) {
			param.ClassName = 'CT.IPMR.BTS.DictionarySrv';
			param.QueryName = 'QryDictionary';
			param.aDicType   = DicType;
			param.aIsActive  = IsActive;
			param.aHospID    = HospID;
			param.ResultSetType = 'array';
		},		
		onLoadSuccess:function(data){
			if (data.length>0){}
		}
	});
	return  cbox;
}

/**
 * 创建诊断库版本combobox
 * @param {arguments[0]} 组件id
 * @return {combobox} 诊断库版本combobox
 * @demo Common_ComboToICDVer("cboICDVer")
 */
function Common_ComboToICDVer(){
	var ItemCode = arguments[0];
	var cbox = $HUI.combobox("#"+ItemCode, {
		url: $URL,
		editable: false,
		defaultFilter:4,
		valueField: 'ID',
		textField: 'Desc',
		onBeforeLoad: function (param) {
			param.ClassName = 'CT.IPMR.FPS.ICDVerSrv';
			param.QueryName = 'QryICDVer';
			param.ResultSetType = 'array';
		}
	});
	return  cbox;
}

/**
 * 创建诊断库版本combobox 依据来源和icd类型
 * @param {arguments[0]} 组件id
 * @param {arguments[1]} 版本来源id
 * @param {arguments[2]} ICD类型id
 * @return {combobox} 诊断库版本combobox
 * @demo Common_ComboToICDVerEdition("cboICDVer","385","387")
 */
function Common_ComboToICDVerEdition(){

	var ItemCode = arguments[0];
	var Edition  = arguments[1];
	var ICDType  = arguments[2];
	var cbox = $HUI.combobox("#"+ItemCode, {
		url: $URL,
		editable: false,
		defaultFilter:4,
		valueField: 'ID',
		textField: 'Desc',
		onBeforeLoad: function (param) {
			param.ClassName = 'CT.IPMR.FPS.ICDVerSrv';
			param.QueryName = 'QryICDVerEdition';
			param.aEditionID= Edition;
			param.aICDType  = ICDType;
			param.ResultSetType = 'array';
		}
	});
	return  cbox;
}

/**
 * 创建号码类型combogrid
 * @param {arguments[0]} 组件id
 * @param {arguments[1]} 病案类型id
 * @return {combogrid} 加载号码类型combogrid
 * @demo Common_CombogNoType("cboICDVer","385","387")
 */
function Common_CombogNoType(){
	var ItemCode = arguments[0];
	var MrTypeId = arguments[2];
	var cbogrid = $HUI.combogrid("#"+ItemCode, {
		url: $URL,
		editable: true,
		panelWidth: 230,
		blurValidValue:true,
		idField: 'ID',
		textField: 'Desc',
		columns: [[
			{field:'Desc',title:'号码类型',width:120},
			{field:'CurrMrNo',title:'当前流水号',width:100}
		]],
		onBeforeLoad: function (param) {
			param.ClassName = 'CT.IPMR.BTS.NoTypeSrv';
			param.QueryName = 'QryMrNoType';
			param.aMrTypeID=MrTypeId;
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){
			// console.log(data);
			$(this).combogrid('setValue', data.rows[0].ID);
		}
	});
	return  cbogrid;
}

/**
 * 渲染字典单选radio
 * @param {arguments[0]} 待渲染组件id
 * @param {arguments[1]} 字典类型代码
 * @param {arguments[2]} 每列显示radio个数/传空默认显示4个
 * @return {void}
 * @demo Common_RadioToDic("radPreStepList","WorkFlowStep",3)	//前提步骤
 * @demo $HUI.radio('#radPreStepList'+dicSubList[1]).setValue(true)		//赋值
 */
function Common_RadioToDic() {
	var ItemCode = arguments[0];
	var DicType = arguments[1];
	var columns = arguments[2]? arguments[2] : 4;
	var strDicList =$m({
		ClassName:"CT.IPMR.BTS.DictionarySrv",
		MethodName:"GetDicsByType",
		aType:DicType,
		aHospID:'',
		aActive:1
	},false);
	var dicList = strDicList.split(String.fromCharCode(1));
    var len = dicList.length;
	var count = parseInt(len/columns)+1;
	var per = Math.round((1/columns) * 100) + '%';   //每列所在百分比
	var listHtml=""
	for (var index =0; index< count; index++) {
		var radlen=(((index+1)*columns)<len) ? (index+1)*columns : len;
		listHtml +="<div>"; 
		for (var dicIndex = index*columns; dicIndex < radlen; dicIndex++) {	
			var dicSubList = dicList[dicIndex].split(String.fromCharCode(2));
			// listHtml += "<div style='float:left;width:"+per+"'><input id="+ItemCode+dicSubList[0]+" type='radio' class='hisui-radio' "+(dicSubList[0]==1? "checked='checked'":"")+" label="+dicSubList[2]+" name="+ItemCode+" value="+dicSubList[1]+"></div>";
			listHtml += "<div style='float:left;width:"+per+"'><input id="+ItemCode+dicSubList[1]+" type='radio' class='hisui-radio' "+(dicSubList[0]==1? "checked='checked'":"")+" label="+dicSubList[2]+" name="+ItemCode+" value="+dicSubList[1]+"></div>";
		} 
		listHtml +="</div>"
	}
	$('#'+ItemCode).html(listHtml); 
    $.parser.parse('#'+ItemCode);  //解析radio
}

/**
 * 渲染字典多选Checkbox(字典项代码为value)
 * @param {arguments[0]} 待渲染组件id
 * @param {arguments[1]} 字典类型代码
 * @param {arguments[2]} 每列显示Checkbox个数/传空默认显示4个
 * @return {void}
 * @demo Common_CheckboxToDic("cbgAdmTypeList","AdmType","3")
 */
function Common_CheckboxToDic() {
	var ItemCode = arguments[0];
	var DicType = arguments[1];
	var columns = arguments[2]? arguments[2] : 4;
	var strDicList =$m({
		ClassName:"CT.IPMR.BTS.DictionarySrv",
		MethodName:"GetDicsByType",
		aType:DicType,
		aHospID:'',
		aActive:1,
	},false);
	var dicList = strDicList.split(String.fromCharCode(1));
	var len =dicList.length;		
	var count = parseInt(len/columns)+1;
	var per = Math.round((1/columns) * 100) + '%';  //每列所在百分比，等比分布
	var listHtml=""
	for (var index =0; index< count; index++) {
		var chklen=(((index+1)*columns)<len) ? (index+1)*columns : len;
		listHtml +="<div>"; 
		for (var dicIndex = index*columns; dicIndex < chklen; dicIndex++) {	
			var dicSubList = dicList[dicIndex].split(String.fromCharCode(2));
			//listHtml += " <div style='float:left;width:"+per+"'><input id="+ItemCode+dicSubList[0]+" type='checkbox' class='hisui-checkbox' "+(dicSubList[0]==1? "checked='true'":"")+" label="+dicSubList[1]+"  name="+ItemCode+"  value="+dicSubList[0]+"></div>";
			listHtml += " <div style='float:left;width:"+per+"'><input id="+ItemCode+dicSubList[1]+" type='checkbox' class='hisui-checkbox' "+(dicSubList[0]==1? "checked='true'":"")+" label="+dicSubList[2]+"  name="+ItemCode+"  value="+dicSubList[1]+"></div>";  
		} 
		listHtml +="</div>"
	}
	$('#'+ItemCode).html(listHtml); 
	$.parser.parse('#'+ItemCode);  //解析checkbox	
}

/**
 * 渲染字典多选Checkbox(字典项id为value)
 * @param {arguments[0]} 待渲染组件id
 * @param {arguments[1]} 字典类型代码
 * @param {arguments[2]} 每列显示Checkbox个数/传空默认显示4个
 * @return {void}
 * @demo Common_CheckboxToDicID("cbgPurposeIDs","LendPurpose","4")
 */
function Common_CheckboxToDicID() {
	var ItemCode = arguments[0];
	var DicType = arguments[1];
	var columns = arguments[2]? arguments[2] : 4;
	var strDicList =$m({
		ClassName:"CT.IPMR.BTS.DictionarySrv",
		MethodName:"GetDicsByType",
		aType:DicType,
		aHospID:'',
		aActive:1,
	},false);
	var dicList = strDicList.split(String.fromCharCode(1));
	var len =dicList.length;		
	var count = parseInt(len/columns)+1;
	var per = Math.round((1/columns) * 100) + '%';  //每列所在百分比，等比分布
	var listHtml=""
	for (var index =0; index< count; index++) {
		var chklen=(((index+1)*columns)<len) ? (index+1)*columns : len;
		listHtml +="<div>"; 
		for (var dicIndex = index*columns; dicIndex < chklen; dicIndex++) {	
			var dicSubList = dicList[dicIndex].split(String.fromCharCode(2));
			listHtml += " <div style='float:left;width:"+per+"'><input id="+ItemCode+dicSubList[0]+" type='checkbox' class='hisui-checkbox' "+(dicSubList[0]==1? "checked='true'":"")+" label="+dicSubList[2]+"  name="+ItemCode+"  value="+dicSubList[0]+"></div>";  
		} 
		listHtml +="</div>"
	}
	$('#'+ItemCode).html(listHtml); 
	$.parser.parse('#'+ItemCode);  //解析checkbox	
}

/**
 * 日期大小比较 格式：2013-03-22
 * @param {startDate} 日期1
 * @param {endDate} 日期2
 * @return {Boolean} false：startDate大于endDate ，true：startDate小于等于endDate 
 */
function Common_CompareDate(startDate,endDate) {
	var startMonth = startDate.substring(5,startDate.lastIndexOf ("-"));
	var startDay = startDate.substring(startDate.length,startDate.lastIndexOf ("-")+1);
	var startYear = startDate.substring(0,startDate.indexOf ("-"));
	var endMonth = endDate.substring(5,endDate.lastIndexOf ("-"));
	var endDay = endDate.substring(endDate.length,endDate.lastIndexOf ("-")+1);
	var endYear = endDate.substring(0,endDate.indexOf ("-"));
	if (Date.parse(startMonth+"/"+startDay+"/"+startYear) > Date.parse(endMonth+"/"+endDay+"/"+endYear)) { 
		return false;
	}
	return true;
}

/**
 * 取n天前日期
 * 1天前	:Common_GetDate(-1,"")
 * 本月第一天:Common_GetDate("","FIRST")
 * 本月最后一天:Common_GetDate("","LAST")
 * @param {n}
 * @param {flg}
 * @return {Date}
 */
function Common_GetDate(n,flg){
	// 当天信息
	var dateToday	= new Date();
	var tYear		= dateToday.getFullYear();
	var tMonth		= dateToday.getMonth() + 1;
	var tDay		= dateToday.getDate();
	// n天后信息
	var DateExpect	= new Date(dateToday);
	DateExpect.setDate(dateToday.getDate()+n);	// n天后日期
	var eYear		= DateExpect.getFullYear();
	var eMonth		= DateExpect.getMonth() + 1;
	var eDay		= DateExpect.getDate();
	// 本月最后一天信息,本月最后一天的"年","月"与当天信息的一致
	if (tMonth=="12") {
		var MonLastDay	= new Date((tYear+1)+"-01-01")
	} else{
		var MonLastDay	= new Date(tYear+"-"+(tMonth+1)+"-01")
	}
	MonLastDay.setDate(MonLastDay.getDate()-1);
	var mlDay		= MonLastDay.getDate();
	if (tMonth >= 1 && tMonth <= 9) {
		tMonth = "0" + tMonth;
	}
	if (tDay >= 1 && tDay <= 9) {
		tDay = "0" + tDay;
	}
	if (eMonth >= 1 && eMonth <= 9) {
		eMonth = "0" + eMonth;
	}
	if (eDay >= 1 && eDay <= 9) {
		eDay = "0" + eDay;
	}
	var strDate		= ""
	if ((flg=="FIRST")&&(!n)) {
		strDate		= tYear+"-"+tMonth+"-01";
	}
	if ((flg=="LAST")&&(!n)) {
		strDate		= tYear+"-"+tMonth+"-"+mlDay;
	}
	if (n.toString()!="") {
		strDate		= eYear+"-"+eMonth+"-"+eDay;
	}
	return strDate;
}

/**
 * 创建用户 combogrid
 * @param {arguments[0]} 组件id
 * @param {arguments[1]} 医护类型代码
 * @return {combogrid} 用户combogrid
 * @demo Common_ComboGridToUser("cboUser",TypeCode);
 */
function Common_ComboGridToUser(){
	var ItemCode= arguments[0];
	var TypeCode = arguments[1];
	if (typeof(ItemCode)=='undefined') ItemCode='';
	if (typeof(TypeCode)=='undefined') TypeCode='';
	var cbox = $HUI.combogrid("#"+ItemCode, {
		url: $URL,
		panelWidth:500,
		panelHeight:250,
		editable: true,
		defaultFilter:4, 
		idField: 'ID',
		textField: 'Desc',
		method:'Post',
		mode:'remote',
		multiple: false,
		enterNullValueClear:false,
		fitColumns:true,
		delay:200,
		columns:[[
		    {field:'Code',title:'工号',width:120},
		    {field:'Desc',title:'姓名',width:120},
		    {field:'CPTDesc',title:'医护人员类型',width:120}
		]],
		queryParams:{
			ClassName:'MA.IPMR.BTS.SSUserSrv',
			QueryName:'QueryUser',
			aAlias:'',
			aTypeCode:TypeCode,
			aUserID:'' ,
			aIsActive:1,
			rows:1000
		},
		keyHandler: {
			up: function(e) {
				navcbg(this,'prev');
				e.preventDefault();
			},
			down: function(e) {
				navcbg(this,'next');
				e.preventDefault();
			},
			enter: function (e) {
				entercbg(this);
				e.preventDefault();
			},
			query: function (q) {
				qrycbg(this,q);
			}
		}
	});
	return  cbox;
}

/**
 * 用户 combogrid 赋值
 * @param {target} 选择器
 * @param {q} 检索关键字
 * @param {id} id值
 * @param {desc} desc 值
 */
function Common_SetComboGridToUserValue(target,q,id,desc) {
	if (typeof(q)=='undefined') q='';
	if (typeof(id)=='undefined') id='';
	if (typeof(desc)=='undefined') desc='';
	var queryParams=$(target).combogrid('options').queryParams;
	$cm({
		ClassName:queryParams.ClassName,
		QueryName:queryParams.QueryName,
		aAlias:q ,
		aTypeCode:queryParams.aTypeCode,
		aICDDxID:id,
		rows:100 
	},function(rs){
		$(target).combogrid('grid').datagrid('loadData',rs);
		if ((id=='')&&(desc=='')){
			$(target).combogrid('clear');
		}else{
			var rid=0,rdesc=0;
			for (i=0;i<rs.total ;i++ )
			{
				var record = rs.rows[i];
				var ID = record.ID;
				var Desc = record.Desc;
				if (ID==id) rid=1;
				if (Desc==desc) rdesc=1;
			}
			if (rid==1){
				$(target).combogrid('setValue',id);
			}else{
				$(target).combogrid('setValue',desc);
			}
		}
	});
}

/**
 * 创建icd combogrid
 * @param {arguments[0]} 组件id
 * @param {arguments[1]} 关联组件
 * @param {arguments[2]} 版本id
 * @param {arguments[3]} 诊断/手术类型id
 * @param {arguments[4]} 有效标志
 * @param {arguments[5]} 诊断D，手术O
 * @return {combogrid} icd combogrid
 * @demo Common_ComboGridToICD("cboICD",'LinkItem',VerID,TypeID,IsActive,cboType);
 */
function Common_ComboGridToICD(){
	var ItemCode= arguments[0];
	var LinkItem= arguments[1];
	var VerID	= arguments[2];
	var TypeID	= arguments[3];
	var IsActive = arguments[4];
	var cboType = arguments[5];
	if (typeof(ItemCode)=='undefined') ItemCode='';
	if (typeof(LinkItem)=='undefined') LinkItem='';
	if (typeof(VerID)=='undefined') VerID='';
	if (typeof(TypeID)=='undefined') TypeID='';
	if (typeof(IsActive)=='undefined') IsActive='';
	if (typeof(cboType)=='undefined') cboType='';
	var cbox = $HUI.combogrid("#"+ItemCode, {
		url: $URL,
		panelWidth:550,
		panelHeight:350,
		editable: true,
		defaultFilter:4, 
		idField: 'ID',
		textField: 'Desc',
		method:'Post',
		mode:'remote',
		multiple: false,
		enterNullValueClear:false,
		fitColumns:true,
		delay:500,
		sortName:'Count',
		sortOrder:'asc',
		columns:[[
		   {field:'ICD10',title:'编码',
				formatter:function(value,row,index)
				{
					var ICD10 = row["ICD10"];
					var InPairCode = row["InPairCode"];
					var ICD = ICD10+InPairCode;
					return ICD;	
				}
			},
		    {field:'Desc',title:'名称'},
		    {field:'OperTypeDesc',title:'手术类型'},
		    {field:'OperLevelDesc',title:'手术级别'},
		    {field:'Count',title:'序号',hidden:'true'}
		]],
		queryParams:{
		    ClassName:'CT.IPMR.FPS.ICDDxSrv',
			QueryName:'QryICDDx',
			aVerID:VerID,
			aTypeID:Common_GetValue(LinkItem),
			aAlias:'' ,
			aIsActive:IsActive,
			aICDDxID:'',
			rows:50
		},
		onLoadSuccess:function(data){
			if (cboType=='D'){
				$(this).combogrid('grid').datagrid("hideColumn", "OperTypeDesc");
				$(this).combogrid('grid').datagrid("hideColumn", "OperLevelDesc");
			}
			if ($(this).combogrid('grid').datagrid('getRows').length == 0) {
				return;
			}else {
				$(this).combogrid('grid').datagrid('selectRow',0);
			}
		},
		keyHandler: {
			up: function(e) {
				navcbg(this,'prev');
				e.preventDefault();
			},
			down: function(e) {
				navcbg(this,'next');
				e.preventDefault();
			},
			enter: function (e) {
				entercbg(this);
				e.preventDefault();
			},
			query: function (q) {
				Qrycbglink(this,q,LinkItem);
			}
		}
	});
	return  cbox;
}
/**
 * icd combogrid 赋值
 * @param {target} 选择器
 * @param {q} 检索关键字
 * @param {id} id值
 * @param {desc} desc 值
 */
function Common_SetComboGridToICDValue(target,q,id,desc) {
	if (typeof(q)=='undefined') q='';
	if (typeof(id)=='undefined') id='';
	if (typeof(desc)=='undefined') desc='';
	var queryParams=$(target).combogrid('options').queryParams;
	$cm({
		ClassName:queryParams.ClassName,
		QueryName:queryParams.QueryName,
		aVerID:queryParams.aVerID,
		aTypeID:queryParams.aTypeID,
		aAlias:q,
		aIsActive:queryParams.aIsActive,
		aICDDxID:id,
		rows:100 
	},function(rs){
		$(target).combogrid('grid').datagrid('loadData',rs);
		if ((id=='')&&(desc=='')){
			$(target).combogrid('clear');
		}else{
			var rid=0,rdesc=0;
			for (i=0;i<rs.total ;i++ )
			{
				var record = rs.rows[i];
				var ID = record.ID;
				var Desc = record.Desc;
				if (ID==id) rid=1;
				if (Desc==desc) rdesc=1;
			}
			if (rid==1){
				$(target).combogrid('setValue',id);
			}else{
				$(target).combogrid('setValue',desc);
			}
		}
	});
}

/**
 * 创建字典 combogrid （ID为value）
 * @param {arguments[0]} 组件id
 * @param {arguments[1]} 字典类型代码
 * @param {arguments[2]} 有效标志
 * @param {arguments[3]} 医院ID
 * @return {combogrid} 字典combogrid
 * @demo Common_ComboGridToDic("cboDic","SYS",1,HospID);
 */
function Common_ComboGridToDic(){
	var ItemCode	= arguments[0];
	var DicType		= arguments[1];
	var IsActive	= arguments[2];
	var HospID		= arguments[3];
	if (typeof(ItemCode)=='undefined') ItemCode='';
	if (typeof(DicType)=='undefined') DicType='';
	if (typeof(IsActive)=='undefined') IsActive='';
	if (typeof(HospID)=='undefined') HospID='';
	var cbox = $HUI.combogrid("#"+ItemCode, {
		url: $URL,
		panelWidth:300,
		panelHeight:250,
		editable: true,
		defaultFilter:4, 
		idField:'ID',
		textField: 'Desc',
		method:'Post',
		mode:'remote',
		multiple: false,
		enterNullValueClear:false,
		fitColumns:true,
		delay:200,
		columns:[[
		    {field:'Code',title:'代码',width:50},
		    {field:'Desc',title:'名称',width:200}
		   ]],
		queryParams:{
		    ClassName:'CT.IPMR.BTS.DictionarySrv',
			QueryName:'QryDictionary',
			aDicType:DicType,
			aIsActive:IsActive,
			aHospID:HospID,
			aAlias:'',
			rows:1000
		},
		keyHandler: {
			up: function(e) {
				navcbg(this,'prev');
				e.preventDefault();
			},
			down: function(e) {
				navcbg(this,'next');
				e.preventDefault();
			},
			enter: function (e) {
				entercbg(this);
				e.preventDefault();
			},
			query: function (q) {
				qrycbg(this,q);
			}
		}
	});
	return  cbox;
}

/**
 * 字典 combogrid 赋值
 * @param {target} 选择器
 * @param {q} 检索关键字
 * @param {id} id值
 * @param {desc} desc 值
 */
function Common_SetComboGridToDicValue(target,q,id,desc) {
	if (typeof(q)=='undefined') q='';
	if (typeof(id)=='undefined') id='';
	if (typeof(desc)=='undefined') desc='';
	var queryParams=$(target).combogrid('options').queryParams;
	$cm({
		ClassName:queryParams.ClassName,
		QueryName:queryParams.QueryName,
		aDicType:queryParams.aDicType,
		aIsActive:queryParams.aIsActive,
		aHospID:queryParams.aHospID,
		aAlias:q,
		rows:100 
	},function(rs){
		$(target).combogrid('grid').datagrid('loadData',rs);
		if ((id=='')&&(desc=='')){
			$(target).combogrid('clear');
		}else{
			var rid=0,rdesc=0;
			for (i=0;i<rs.total ;i++ )
			{
				var record = rs.rows[i];
				var ID = record.ID;
				var Desc = record.Desc;
				if (ID==id) rid=1;
				if (Desc==desc) rdesc=1;
			}
			if (rid==1){
				$(target).combogrid('setValue',id);
			}else{
				$(target).combogrid('setValue',desc);
			}
		}
	});
}

/**
 * 下拉框回车动作调用函数
 * @param {target} 选择器
 * @return {void}
 */
function entercbg(target) {
	var state = $.data(target,"combogrid");;
	var opts = state.options;
	var grid = state.grid;
	var panel = $.data(target,"combo").panel;
	if(panel.is(':visible')) {
		var tr = opts.finder.getTr(grid[0],null,"highlight");
		state.remainText = false;
		if(tr.length){
			var _31 = parseInt(tr.attr("datagrid-row-index"));
			if(opts.multiple){
				if(tr.hasClass("datagrid-row-selected")){
					grid.datagrid("unselectRow",_31);
				}
				else{
					grid.datagrid("selectRow",_31);
				}
			}else{
				grid.datagrid("selectRow",_31);
			}
		}
		var vv=[];
		$.map(grid.datagrid("getSelections"),function(row){
			vv.push(row[opts.idField]);
		});
		$(target).combogrid("setValues",vv);
		if(!opts.multiple){
			$(target).combogrid("hidePanel");
		}
	}
	else{
		$(target).combogrid("showPanel");
		var q = $(target).combogrid("textbox").val();
		if (state.previousValue != q) {
			state.previousValue = q;
			opts.keyHandler.query.call(target, q);
		}
		$(target).combogrid("validate");
	}
}

/**
 * 下拉框关联检索
 * @param {target} 选择器
 * @param {q} 关键字
 * @param {linkvalue} 关联值
 * @return {void}
 */
function Qrycbglink(target,q,LinkItem) {
	var state = $.data(target,"combogrid");
	var opts = state.options;
	var grid = state.grid;
	state.remainText = true;
	if(opts.multiple&&!q){
		_1ag(target,[],true);
	}
	else{
		_1ag(target,[q],true);
	}
	if(opts.mode=="remote"){
		grid.datagrid("clearSelections");
		if (LinkItem=='') {
			var typeID = '';
		}else{
			if ($('#'+LinkItem).hasClass('combogrid-f')) {
				var typeID = $('#'+LinkItem).combobox('getValue');
			}else{
				var typeID = $('#'+LinkItem).val();
			}
		}
		grid.datagrid("load",$.extend({},opts.queryParams,{aAlias:q,aTypeID:typeID}));
	}
	else{
		if(!q){
			return;
		}
		grid.datagrid("clearSelections").datagrid("highlightRow",-1);
		var _2b = grid.datagrid("getRows");
		var qq = opts.multiple?q.split(opts.separator):[q];
		$.map(qq,function(q){
			q=$.trim(q);
			if(q){
				$.map(_2b,function(row,i){
					if(q==row[opts.textField]){
						grid.datagrid("selectRow",i);
					}
					else{
						if(opts.filter.call(target,q,row)){
							grid.datagrid("highlightRow",i);
						}
					}
				});
			}
		});
	}
}

/**
 * 下拉框检索
 * @param {target} 选择器
 * @param {q} 关键字
 * @return {void}
 */
function qrycbg(target,q) {
	var state = $.data(target,"combogrid");
	var opts = state.options;
	var grid = state.grid;
	state.remainText = true;
	if(opts.multiple&&!q){
		_1ag(target,[],true);
	}
	else{
		_1ag(target,[q],true);
	}
	if(opts.mode=="remote"){
		grid.datagrid("clearSelections");
		grid.datagrid("load",$.extend({},opts.queryParams,{aAlias:q}));
	}
	else{
		if(!q){
			return;
		}
		grid.datagrid("clearSelections").datagrid("highlightRow",-1);
		var _2b = grid.datagrid("getRows");
		var qq = opts.multiple?q.split(opts.separator):[q];
		$.map(qq,function(q){
			q=$.trim(q);
			if(q){
				$.map(_2b,function(row,i){
					if(q==row[opts.textField]){
						grid.datagrid("selectRow",i);
					}
					else{
						if(opts.filter.call(target,q,row)){
							grid.datagrid("highlightRow",i);
						}
					}
				});
			}
		});
	}
	state.remainText = false;
}
/**
 * 下拉框上下键导航
 * @param {target} 选择器
 * @param {dir} next or prev
 * @return {void}
 */
function navcbg(target,dir) {
	var state = $.data(target,"combogrid");
	var opts = state.options;
	var grid = state.grid;
	var _18 = grid.datagrid("getRows").length;
	if (!_18) {
		return;
	}
	var tr = opts.finder.getTr(grid[0],null,"highlight");
	if (!tr.length) {
		tr = opts.finder.getTr(grid[0],null,"selected");
	}
	var _19;
	if (!tr.length) {
		_19 = (dir=="next"?0:_18-1);
	} else {
		var _19 = parseInt(tr.attr("datagrid-row-index"));
		_19 += (dir=="next"?1:-1);
		if (_19 < 0) {
			_19 = _18-1;
		}
		if	(_19 >= _18)	{
			_19 = 0;
		}
	}
	grid.datagrid("highlightRow",_19);
	if(opts.selectOnNavigation){
		state.remainText = false;
		grid.datagrid("selectRow",_19);
	}
}
function _1ag(_1b,_1c,_1d){
	var _1e=$.data(_1b,"combogrid");
	var _1f=_1e.options;
	var _20=_1e.grid;
	var _21=_20.datagrid("getRows");
	var ss=[];
	var _22=$(_1b).combo("getValues");
	var _23=$(_1b).combo("options");
	var _24=_23.onChange;
	_23.onChange=function(){
	};
	_20.datagrid("clearSelections");
	for(var i=0;i<_1c.length;i++){
		var _25=_20.datagrid("getRowIndex",_1c[i]);
		if(_25>=0){
			_20.datagrid("selectRow",_25);
			ss.push(_21[_25][_1f.textField]);
		}else{
			ss.push(_1c[i]);
		}
	}
	$(_1b).combo("setValues",_22);
	_23.onChange=_24;
	$(_1b).combo("setValues",_1c);
	if(!_1d){
		var s=ss.join(_1f.separator);
		if($(_1b).combo("getText")!=s){
			$(_1b).combo("setText",s);
		}
	}
}

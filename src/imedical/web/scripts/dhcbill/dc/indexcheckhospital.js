/**
 * FileName: dhcbill.dc.indexcheckhospital.js
 * Author: Lizhi
 * Date: 2022-05-31
 * Description: 指标核查结果
 */
var IndicatorRowid="";
var GV = {
	CLASSNAME:"BILL.DC.BL.DicDataCtl",
	CKRCLASSNAME:"BILL.DC.BL.IndicatorDefCtl",
	CKRDCLASSNAME:"BILL.DC.BL.CheckResultDetCtl",
	CkDetData:""
};
var DicBusinessTypeList=[];//业务类型
var DicLevelList=[]; //异常等级
var DicHISVerList=[];
var ComboboxHISVerList=[];
var RefHISVerNum=-1;//参考版本号数量
var HISVerListNum=-1;//his版本号原始数量
var HISVerComIndex=-1;//his版本号空值位置，下拉框摆放位置
var EditingList=[];//正在编辑的列
$(function() {
	$("#search1").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			loadConfPage();
		}
	});
	$('#dhcinsutarEdit').window("close");
	//初始化查询下拉框
	getdicHisVerList();
	getDicBusinesstypeList();
	getDicLevelList();
	init_QBusinessTypeIdCB("G");//暂时写死2，后续增加通用指标院区
	init_QCheckTypeCB("G");
	init_QExceptionLevalCB("G");
	init_DG();
	init_ckDetDG();
	loadConfPage();
	//loadHospitalPage();
	
	//LoadDicHosHisVer();
	
	//初始化编辑页面下拉框
	init_CheckTypeCB("G");
	init_BusinessTypeIdCB("G");
	init_EXlevelIdCB("G");
	init_ActiveFlagCB("G");
	init_IndicatorTypeIdCB("G");
});
//清除下边的form
function clearQform(){
	//init_QBusinessTypeIdCB("G");
	//init_QCheckTypeCB("G");
	//init_QExceptionLevalCB("G");
	setValueById('QCheckType','');
	setValueById('QBusinessType','');
	setValueById('QExceptionLeval','');
	$("#search1").val("");
	loadConfPage();	
}
function init_QCheckTypeCB(HospID){
	$HUI.combobox("#QCheckType", {
		panelHeight: 150,
		url: $URL,
		valueField: 'DicCode',
		textField: 'DicDesc',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.DC.BL.DicDataCtl";
			param.QueryName = "QueryInfo";
			param.HospID = HospID;
			param.KeyCode="";
			param.PDicType= "CheckType";
			param.ExpStr= "";
			param.ResultSetType = 'array';
			return true;
		},
		onLoadSuccess: function (data) {
		},
		onChange:function(val){
			//loadConfPage();
		}
	});
}
function init_QBusinessTypeIdCB(HospID){
	$HUI.combobox("#QBusinessType", {
		panelHeight: 150,
		url: $URL,
		valueField: 'DicCode',
		textField: 'DicDesc',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.DC.BL.DicDataCtl";
			param.QueryName = "QueryInfo";
			param.HospID = HospID;
			param.KeyCode="";
			param.PDicType= "BusinessTypeCode";
			param.ResultSetType = 'array';
			return true;
		},
		onLoadSuccess: function (data) {
		},
		onChange:function(val){
			//loadConfPage();
		}
	});
}
function init_QExceptionLevalCB(HospID){
	$HUI.combobox("#QExceptionLeval", {
		panelHeight: 150,
		url: $URL,
		valueField: 'DicCode',
		textField: 'DicDesc',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.DC.BL.DicDataCtl";
			param.QueryName = "QueryInfo";
			param.HospID = HospID;
			param.KeyCode="";
			param.PDicType= "ExceptionLevel";
			param.ExpStr= "";
			param.ResultSetType = 'array';
			return true;
		},
		onLoadSuccess: function (data) {

		},
		onChange:function(val){
			//loadConfPage();
		}
	});
}

function init_ckDetDG(){
	GV.ckDet =$HUI.datagrid("#ckDet", {
		fit: true,
		border: false,
		singleSelect: true,
		pageSize: 1000,
		pageList:[1000],
		pagination: true,
		displayMsg: '',
		idField: 'Rowid',
		sortName:'UPDTDATE',
		sortOrder:'desc',
		columns: [[
			//{title:'选择', checkbox:true, width: 50},
/* 			{field:'TOpt',width:40,title:'操作',align:'center',
			formatter: function (value, row, index) {
		   		return "<img class='myTooltip' style='width:60' title='修改' onclick=\"indicatorEditClick('" + index+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper_pen.png' style='border:0px;cursor:pointer'>";
			}}, */
			{field:'BusinessTypeCode',title:'业务类型',width:80,//editor:BusinessTypeCommbobox
				 formatter: function (value, row, index) {
					//var rtn = tkMakeServerCall("BILL.DC.BL.DicDataCtl","GetDicInfoByTypeCode","BusinessTypeCode", value, "G","2");
					var rtn="";
					for (var i=0;i<DicBusinessTypeList.length;i++)
					{
						if(DicBusinessTypeList[i].DicCode==value)
						{
							rtn=DicBusinessTypeList[i].DicDesc;
							break;
						}
					}
					return rtn=="" ? value : rtn;
				}
			},
			{field:'Code',title:'指标代码',width:80,hidden:true},
			{field:'Name',title:'指标名称',width:480,tipPosition:"top",showTip:true
/* 				formatter: function (value, row, index) {
					return "(" + row.HISVer.split(",").length + ')' + value;
				} */
			},
			/* {field:'CheckType',title:'核查分类',width:180,hidden:true,
				formatter: function (value, row, index) {
					var rtn = tkMakeServerCall("BILL.DC.BL.DicDataCtl","GetDicInfoByTypeCode","CheckType", value, "G","2");
					return rtn=="" ? value : rtn;
				}
			}, */
			{field:'ActiveFlag',title:'是否有效',width:80,hidden:true},
			{field:'BusinessTypeDesc',title:'指标业务类型描述',width:80,tipPosition:"top",showTip:true,hidden:true},
			{field:'ExecClass',title:'执行类名',width:120,hidden:true},
			{field:'ExecClassMethod',title:'类方法名',width:350,tipPosition:"top",showTip:true,hidden:true},
			{field:'IndicatorTypeId',title:'指标类型',width:80,hidden:true},
			{field:'EXlevelId',title:'异常等级',width:80,//editor:LevelCommbobox
				 formatter: function (value, row, index) {
					//var rtn = tkMakeServerCall("BILL.DC.BL.DicDataCtl","GetDicInfoByTypeCode","ExceptionLevel", value, "G","2");
					var rtn="";
					for (var i=0;i<DicLevelList.length;i++)
					{
						if(DicLevelList[i].DicCode==value)
						{
							rtn=DicLevelList[i].DicDesc;
							break;
						}
					}
					return rtn=="" ? value : rtn;
				}
			},
			{field:'Description',title:'监控点说明',width:280,tipPosition:"top",showTip:true},
			{field:'HISVer',title:'HIS版本号',width:50,width:10,hidden:true},
			{field:'CRTER',title:'创建人',width:50,width:10,hidden:true},
			{field:'CRTEDATE',title:'创建日期',width:50,width:10,hidden:true},
			{field:'CRTETIME',title:'创建时间',width:50,width:10,hidden:true},
			{field:'UPDTID',title:'更新人',width:50,width:10,hidden:true},
			{field:'UPDTDATE',title:'更新日期',width:50,width:10,hidden:true},
			{field:'UPDTTIME',title:'更新时间',width:50,width:10,hidden:true},
			{field:'RowId',title:'Rowid',width:10,hidden:true}
			]],
		onLoadSuccess: function(data) {
		},
		onBeforeLoad: function(param) {
			$('#dg').datagrid('uncheckAll');
			$('#ckDet').datagrid('unselectAll');
			var options=$('#ckDet').datagrid('getPager').data('pagination').options;
			var PageNum=options.pageNumber;
			var PageSize=options.pageSize;
			var JsonObj={total:GV.CkDetData["total"],rows:[],curPage:GV.CkDetData["curPage"]};
			for (i =((PageNum-1)*PageSize); i < GV.CkDetData.rows.length; i++) {
			    if(i===(PageSize*PageNum))
			    {
			    	break;
			    }
			    JsonObj.rows.push(GV.CkDetData.rows[i]);
			}
			$('#ckDet').datagrid('loadData',JsonObj);
		},
		onSelect: function(index, row) {
			$('#btnAddHisVer').linkbutton({disabled:false});	
			changeHospital(row);
		},
/* 		onDblClickRow:function(rowIndex, rowData){
		   indicatorEditClick(rowIndex);
		   $('#ckDet').datagrid('checkRow',rowIndex);
		}, */
	});
}

var hospitalArr=[];//记录指标已经保存院区

function changeHospitalbak(row){
	//loadHospitalPage();
	hospitalArr=[];
	var Code=row["Code"];
	$('#dg').datagrid('uncheckAll');
	var BusinessTypeCode=row["BusinessTypeCode"];
	var interfaceName = $.cm({
        ClassName: GV.CKRCLASSNAME,
		QueryName: "QueryInfo",
		//QName:row["Name"],
		QBusinessType:BusinessTypeCode,
		KeyCode:Code,
		PCheckType:"",
		rows:999999
		}, false);
	for(i=0;i<interfaceName.rows.length;i++)
	{
		var HospDr=interfaceName.rows[i]["HospDr"];
		var HosRows=$('#dg').datagrid('getData');
		for(j=0;j<HosRows.rows.length;j++)
		{
			if(HospDr==HosRows.rows[j]["HOSPRowId"])
			{
				var row=HosRows.rows[j];
				row["Rowid"]=interfaceName.rows[i]["Rowid"];
				$('#dg').datagrid('updateRow',{
					index: j,
					row:row
				});
				$('#dg').datagrid('checkRow',j);
				var obj={};
				obj["HosDr"]=HospDr;
				obj["Rowid"]=interfaceName.rows[i]["Rowid"];
				hospitalArr.push(obj);
			}
		}
	}
}
//获取字典版本号集合
function getdicHisVerList(){
	var ExtJsonStr = $.cm({
		ClassName: "BILL.DC.BL.DicDataCtl",
		QueryName: "QueryInfo",
		ResultSetType:"array",
		HospID:"G",
		PDicType:"HISVerCode"
	}, false);
	if(ExtJsonStr.length){
		for(var i=0;i<ExtJsonStr.length;i++)
		{
			var obj={};
			obj.DicCode=ExtJsonStr[i].DicCode;
			obj.DicDesc=ExtJsonStr[i].DicDesc;
			DicHISVerList.push(obj);	
		}
	}
}
//获取字典业务类型集合
function getDicBusinesstypeList(){
	var ExtJsonStr = $.cm({
		ClassName: "BILL.DC.BL.DicDataCtl",
		QueryName: "QueryInfo",
		ResultSetType:"array",
		HospID:"G",
		PDicType:"BusinessTypeCode"
	}, false);
	if(ExtJsonStr.length){
		for(var i=0;i<ExtJsonStr.length;i++)
		{
			var obj={};
			obj.DicCode=ExtJsonStr[i].DicCode;
			obj.DicDesc=ExtJsonStr[i].DicDesc;
			DicBusinessTypeList.push(obj);	
		}
	}
}
//获取字典异常等级集合
function getDicLevelList(){
	var ExtJsonStr = $.cm({
		ClassName: "BILL.DC.BL.DicDataCtl",
		QueryName: "QueryInfo",
		ResultSetType:"array",
		HospID:"G",
		PDicType:"ExceptionLevel"
	}, false);
	if(ExtJsonStr.length){
		for(var i=0;i<ExtJsonStr.length;i++)
		{
			var obj={};
			obj.DicCode=ExtJsonStr[i].DicCode;
			obj.DicDesc=ExtJsonStr[i].DicDesc;
			DicLevelList.push(obj);	
		}
	}
}
function AddNewHISVer(){
	//buildHISVerComboboxData();
	//var getdgHisVerrows=$('#dg').datagrid('getRows');
	/* if(RefHISVerNum<=HISVerComIndex)
	{
		$('#dg').datagrid('appendRow',{
			ReferenceHISVer: '',
			DicCode:''
		});
		$('#dg').datagrid('beginEdit',HISVerComIndex);
	}
	else
	{
		$('#dg').datagrid('beginEdit',HISVerComIndex);
	} */
	//结束所有编辑状态
	if(EditingList.length>0)
	{
		for(var i=0;i<EditingList.length;i++)
		{
			$('#dg').datagrid('endEdit',EditingList[i]);
		}
		EditingList=[];
	}
	//判断当前空值位置及是否新增空白行赋值
	var addrow=false;
	var rows=$('#dg').datagrid('getRows');
	for(var i=0;i<rows.length;i++)
	{
		if(rows[i].DicCode=="" || rows[i].DicCode==undefined)
		{
			HISVerComIndex=i;
			break;
		}
		if(rows[i].DicCode!="" && i== rows.length-1)
		{
			addrow=true;
		}
	}
	if(addrow)
	{
		$('#dg').datagrid('appendRow',{
			ReferenceHISVer: '',
			DicCode:''
		});
		HISVerComIndex=$('#dg').datagrid('getRows').length-1;
	}
	
	$('#dg').datagrid('beginEdit',HISVerComIndex);
	EditingList.push(HISVerComIndex);
}
//构造his版本号下拉框数据 ----停用-----
function buildHISVerComboboxData(){
	
	var getdgHisVerrows=$('#dg').datagrid('getRows');
	var HisVerStr='';
	if(getdgHisVerrows!="")
	{
		for (var i=0;i<getdgHisVerrows.length;i++)
		{
			if(getdgHisVerrows[i].DicCode!=undefined && getdgHisVerrows[i].DicCode!='')
			{
				HisVerStr+=getdgHisVerrows[i].DicCode+';';
			}
		}
	}
	for(var i=0;i<DicHISVerList.length;i++)
	{
		if(HisVerStr.indexOf(DicHISVerList[i].DicCode)==-1)
		{
			var obj={};
			obj.DicDesc=DicHISVerList[i].DicDesc;
			obj.DicCode=DicHISVerList[i].DicCode;
			ComboboxHISVerList.push(obj);
		}
	}
}
//版本号下拉框数据
var HisVerCommbobox={
				type: 'combobox', //设置编辑格式
				options: {
					panelHeight: 160,
					//url: $URL,
					editable: false,
					valueField: 'DicCode',
					textField: 'DicDesc',
					defaultFilter: 6,
					mode:'remote',
					data:DicHISVerList,
					onSelect:function(option){
						//HISVerComIndex+=1;
					}
					/* onBeforeLoad: function (param) {
									ClassName: "BILL.DC.BL.DicDataCtl";
									QueryName: "QueryInfo";
									ResultSetType:"array";
									HospID:"G";
									PDicType:"HISVerCode";
									return true;
								}, */
				
				}
			}
function EastBeginEdit(dg,index,row){
	var SelectIndex = INSUMIGetEditRowIndexByID(dg);
	 if(SelectIndex > -1 ) {
		if (!$('#' + dg).datagrid('validateRow', SelectIndex)) {
			$.messager.popover({msg: '数据验证不通过', type: 'error'});
			return;
		}
		$('#' + dg).datagrid('endEdit',SelectIndex);
	}
	$('#' + dg).datagrid('beginEdit',index);
	
}
function INSUMIGetEditRowIndexByID(gridId){
	var tr = $('#' + gridId).siblings().find('.datagrid-editable').parent().parent();//
	var SelectIndex = tr.attr('datagrid-row-index') || -1; 
	return SelectIndex
}
function changeHospital(row){
	//$('#dg').datagrid('uncheckAll');
	$('#dg').datagrid('loadData',{total:0,rows:[]});
	//-----zjb add 2022.11.01
	var dgData=[];
	var RefHISVer=[];//参考版本号
	var HISVerList=[];//版本号
	if(row.ReferenceHISVer!=undefined && row.ReferenceHISVer!='')
	{
		if(row.ReferenceHISVer.indexOf(',')!=-1)
		{
			RefHISVer=row.ReferenceHISVer.split(",");
		}
		else
		{
			RefHISVer.push(row.ReferenceHISVer);
		}
	}
	if(row.HISVer!=undefined && row.HISVer!='')
	{
		if(row.HISVer.indexOf(',')!=-1)
		{
			HISVerList=row.HISVer.split(",");
		}
		else
		{
			HISVerList.push(row.HISVer);
		}
	}
	RefHISVerNum=RefHISVer.length;
	HISVerListNum=HISVerList.length;
	
	HISVerComIndex=HISVerListNum;  //his版本号空值位置
	
	if(RefHISVerNum>=HISVerListNum)
	{
		for(var i=0;i<RefHISVerNum;i++)
		{
			if(i<HISVerListNum)
			{
				var obj={};
				obj.ReferenceHISVer=RefHISVer[i];
				obj.DicCode=HISVerList[i];
				dgData.push(obj);
			}
			else
			{
				var obj={};
				obj.ReferenceHISVer=RefHISVer[i];
				obj.DicCode='';
				dgData.push(obj);
			}
		}
	}
	else
	{
		for(var i=0;i<HISVerListNum;i++)
		{
			if(i<RefHISVerNum)
			{
				var obj={};
				obj.ReferenceHISVer=RefHISVer[i];
				obj.DicCode=HISVerList[i];
				dgData.push(obj);
			}
			else
			{
				var obj={};
				obj.ReferenceHISVer='';
				obj.DicCode=HISVerList[i];
				dgData.push(obj);
			}
		}
	}
	//var noneobj={DicCode:""};
	//dgData.push(noneobj);
	$('#dg').datagrid('loadData',dgData);
	//原代码
	/* var interfaceName = row.HISVer.split(",");
	var HISVerLen = interfaceName.length;
	for(i=0;i<HISVerLen;i++)
	{
		var HisVer=interfaceName[i];
		var HosRows=$('#dg').datagrid('getData');
		for(j=0;j<HosRows.rows.length;j++)
		{
			if(HisVer==HosRows.rows[j]["DicCode"])
			{
				$('#dg').datagrid('checkRow',j);
				var obj={};
				obj["HosDr"]=HisVer;
				obj["Rowid"]=HisVer;
				hospitalArr.push(obj);
			}
		}
	} */
}
function init_DG(){
	GV.MontList =$HUI.datagrid("#dg", {
		fit: true,
		border: false,
		singleSelect: false,
		pagination: false,
		pageSize: 1000,
		pageList:[1000],
		displayMsg: '',
/* 		frozenColumns:[[
		]], */
		columns: [[
			//{title:'选择', field: 'CheckOrd',checkbox:true, width: 50},
			/* {field:'RowId',title:'院区代码',width:80,hidden:true,formatter:function(val,index,row){
				return row. DicCode;	
			}},
			{field:'HOSPRowId',title:'院区代码',width:80,hidden:true,formatter:function(val,index,row){
				return row. DicCode;	
			}},
			{field:'HOSPDesc',title:'院区名称',width:280,hidden:true,formatter:function(val,index,row){
				return row. DicCode;	
			}}, */
			{field:'ReferenceHISVer',title:'参考版本号(双击添加)',width:150},
			{field:'DicCode',title:'已授权版本号(双击删除)',width:160,editor:HisVerCommbobox//{type: 'text'}
		    /* {
				type: 'combobox', //设置编辑格式
				options: {
					panelHeight: 150,
					url: $URL,
					editable: false,
					valueField: 'DicCode',
					textField: 'DicDesc',
					defaultFilter: 4,
					mode:'remote',
					onBeforeLoad: function (param) {
									ClassName: "BILL.DC.BL.DicDataCtl";
									QueryName: "QueryInfo";
									ResultSetType:"array";
									HospID:"G";
									PDicType:"HISVerCode";
									return true;
								},
				}
			} */
			}
			]],
		onLoadSuccess: function(data) {
			GV.MontList.unselectAll();
		},
		onCheckAll:function() {
			var indicatordef=$('#ckDet').datagrid('getSelected');
			if(!indicatordef){			
				$.messager.popover({
					msg:'请先选择指标',
					type:'error'	
				});
				$('#dg').datagrid('uncheckAll');	
				$('#dg').datagrid('unselectAll');		
			}
		},
		onCheck: function(index, row) {
			var indicatordef=$('#ckDet').datagrid('getSelected');
			if(!indicatordef){			
				$.messager.popover({
					msg:'请先选择指标',
					type:'error'	
				});
				$('#dg').datagrid('uncheckRow',index);	
				$('#dg').datagrid('unselectRow',index);		
			}
		},
		onSelect: function(index, row) {
			var indicatordef=$('#ckDet').datagrid('getSelected');
			if(!indicatordef){			
				$.messager.popover({
					msg:'请先选择指标',
					type:'error'	
				});
				$('#dg').datagrid('uncheckRow',index);	
				$('#dg').datagrid('unselectRow',index);		
			}
		},
		onDblClickCell:function(index,field,value){
			if(field=='ReferenceHISVer')
			{
				//结束所有编辑状态
				if(EditingList.length>0)
				{
					for(var i=0;i<EditingList.length;i++)
					{
						$('#dg').datagrid('endEdit',EditingList[i]);
					}
					EditingList=[];
				}
				//判断当前空值位置及是否新增空白行赋值
				var addrow=false;
				var rows=$('#dg').datagrid('getRows');
				for(var i=0;i<rows.length;i++)
				{
					if(rows[i].DicCode=="" || rows[i].DicCode==undefined)
					{
						HISVerComIndex=i;
						break;
					}
					if(rows[i].DicCode!="" && i== rows.length-1)
					{
						addrow=true;
					}
				}
				if(addrow)
				{
					$('#dg').datagrid('appendRow',{
						ReferenceHISVer: '',
						DicCode:''
					});
					HISVerComIndex=$('#dg').datagrid('getRows').length-1;
				}
				
				var rowdata=rows[HISVerComIndex];
				$('#dg').datagrid('updateRow',{
					index: HISVerComIndex,
					row: {
						ReferenceHISVer: rowdata.ReferenceHISVer,
						DicCode: value
					}
				});
				/* rows=$('#dg').datagrid('getRows');
				for(var i=0;i<rows.length;i++)
				{
					if(rows[i].DicCode==""||rows[i].DicCode==undefined)
					{
						HISVerComIndex=i;
						break;
					}
					if(rows[i].DicCode!="" && i== rows.length-1)
					{
						HISVerComIndex=$('#dg').datagrid('getRows').length-1;
					}
				} */
			}
			if(field=='DicCode')
			{
				var rows=$('#dg').datagrid('getRows');
				var rowdata=rows[index];
				if(rowdata.DicCode!="" && rowdata.DicCode!=undefined)
				{
					$.messager.confirm("提示", "是否确认删除？", function (r) {
						if (r) {
							$('#dg').datagrid('updateRow',{
								index: index,
								row: {
									ReferenceHISVer: rowdata.ReferenceHISVer,
									DicCode: ""
								}
							});
						}
					});
				}
			/* 	rows=$('#dg').datagrid('getRows');
				for(var i=0;i<rows.length;i++)
				{
					if(rows[i].DicCode==""||rows[i].DicCode==undefined)
					{
						HISVerComIndex=i;
						break;
					}
					if(rows[i].DicCode!="" && i== rows.length-1)
					{
						HISVerComIndex=$('#dg').datagrid('getRows').length-1;
					}
				} */
				//EditingList.push(index);
				//$('#dg').datagrid('beginEdit',index); 
			}
			//EastBeginEdit("#dg",rowIndex, rowData);
		   //$('#dg').datagrid('checkRow',rowIndex);
		},
	});
	
}
function loadConfPage() {
	//$('#dg').datagrid('uncheckAll');
	$('#ckDet').datagrid('unselectAll');
	$('#dg').datagrid('loadData',{total:0,rows:[]});
	var options=$('#ckDet').datagrid('getPager').data('pagination').options;
	var PageSize=options.pageSize;
 	var ExtJsonObj = $.cm({
		ClassName: GV.CKRCLASSNAME,
		QueryName: "QueryInfo",
		HospID:"",//PUBLIC_CONSTANT.SESSION.HOSPID,
		PCheckType:getValueById('QCheckType'),
		KeyCode:getValueById('search1'),
		QBusinessType:getValueById('QBusinessType'),
		QExceptionLeval:getValueById('QExceptionLeval'),
		rows:999999
	}, false);
	//去重
	for (i = 0; i < ExtJsonObj.rows.length; i++) {
        for (j = i+1; j < ExtJsonObj.rows.length; j++) {//&&ExtJsonObj.rows[i]["Name"] == ExtJsonObj.rows[j]["Name"]
            if (ExtJsonObj.rows[i]["Code"] == ExtJsonObj.rows[j]["Code"]&&ExtJsonObj.rows[i]["BusinessTypeCode"] == ExtJsonObj.rows[j]["BusinessTypeCode"]) {
                ExtJsonObj.rows.splice(j, 1);
                j=j-1;
            }
        }
    }
    ExtJsonObj["total"]=ExtJsonObj.rows.length;
    ExtJsonObj["curPage"]=parseInt(ExtJsonObj.total/PageSize)+1;
    GV.CkDetData=ExtJsonObj;
    var JsonObj={total:ExtJsonObj["total"],rows:[],curPage:ExtJsonObj["curPage"]};
    for (i = 0; i < ExtJsonObj.rows.length; i++) {
	    if(i===PageSize)
	    {
	    	break;
	    }
	    JsonObj.rows.push(ExtJsonObj.rows[i]);
    }
 	$('#ckDet').datagrid('loadData',JsonObj); 
}

function loadHospitalPage() {
	$('#dg').datagrid('loadData',{total:0,rows:[]});
	var ExtJsonStr = $.cm({
		ClassName: "BILL.DC.BL.DicDataCtl",
		QueryName: "QueryInfo",
		ResultSetType:"array",
		HospID:"G",
		PDicType:"HISVerCode",
	}, false);
	$('#dg').datagrid('loadData',ExtJsonStr);
	
/* 	var queryParams = {
		ClassName: "web.DHCBL.BDP.BDPMappingHOSP",
		QueryName: "GetHospDataForCombo",
		ResultSetType:"array",
		tablename:"User.INSUTarContrast"
	}
	loadDataGridStore("dg", queryParams); */
}

/* function LoadDicHosHisVer(){
	$('#RefHISVer').datagrid('loadData',{total:0,rows:[]});
	var ExtJsonStr = $.cm({
		ClassName: "BILL.DC.BL.DicDataCtl",
		QueryName: "QueryInfo",
		ResultSetType:"array",
		HospID:session['LOGON.HOSPID'],
		PDicType:"SYS",
	}, false);
	var DicHisVerList=[];
	for(var i=0;i<ExtJsonStr.length;i++)
	{
		if(ExtJsonStr[i].DicCode=='HISVer')
		{
			DicHisVerList.push(ExtJsonStr[i]);
		}
	}
	$('#RefHISVer').datagrid('loadData',DicHisVerList);
} */
function btnSave(){
	//var indicatordefList=$('#ckDet').datagrid('getChecked');getSelected
	var indicatordefList=$('#ckDet').datagrid('getSelections');
	if(indicatordefList.length<1) 
	{
		$.messager.alert('提示', "请先选择左边指标!", "info", function() {
			});
		return;	
	}
	if(EditingList.length>0)
	{
		for(var i=0;i<EditingList.length;i++)
		{
			$('#dg').datagrid('endEdit',EditingList[i]);
		}
		EditingList=[];
	}
	
	//var hospitalArrNew=$('#dg').datagrid('getChecked');getRows
	var hospitalArrNew=$('#dg').datagrid('getRows');
	if(hospitalArrNew.length=="0")
	{
		$.messager.alert('提示', "请至少添加一个版本号!", "info", function() {
			});
		return;	
	}
	var succsescount=0;
	var errcount=0;
	for(i=0;i<indicatordefList.length;i++)
	{
		var HisVerStr ="";
		for(j=0;j<hospitalArrNew.length;j++)
		{
			//过滤空值及重复值
			if(hospitalArrNew[j]["DicCode"]!='' && HisVerStr.indexOf(hospitalArrNew[j]["DicCode"])==-1)
			{
				if(HisVerStr==""){
					HisVerStr = hospitalArrNew[j]["DicCode"];	
				}else{
					HisVerStr = HisVerStr + "," + 	hospitalArrNew[j]["DicCode"];		
				}
			}
		}
		if(HisVerStr=="")
		{
			$.messager.alert('提示', "请至少添加一个版本号!", "info", function() {
			});
			continue;	
		}
		var InputJson = {
			"HISVer":HisVerStr
		}
		var RowId=indicatordefList[i].Rowid;
		var savecode=tkMakeServerCall(GV.CKRCLASSNAME,"UpdaeByJson",JSON.stringify(InputJson),RowId);
		if(savecode==0){
			succsescount+=1;
		}else{	
			errcount+=1;
		}
		var indexrow=$('#ckDet').datagrid('getRowIndex',indicatordefList[i]);
		$('#ckDet').datagrid('updateRow',{
			index: indexrow,
			row: {
				HISVer: HisVerStr,
				Name: indicatordefList[i]['Name']
			}
		});
	}
	$.messager.alert('提示','授权成功'+succsescount+"条,失败"+errcount+"条",'info');

/* 	var indicatordef=$('#ckDet').datagrid('getSelected');
	if(typeof(indicatordef)=="undefined"||indicatordef==null)
	{
		$.messager.alert('提示', "请先选择指标!", "info", function() {
			});
		return;	
	}
	var hospitalArrNew=$('#dg').datagrid('getChecked');
	if(hospitalArrNew.length=="0")
	{
		$.messager.alert('提示', "请至少选择一个版本号!", "info", function() {
			});
		return;	
	}
	var HisVerStr ="";
	for(j=0;j<hospitalArrNew.length;j++)
	{
		if(HisVerStr==""){
			HisVerStr = hospitalArrNew[j]["DicCode"];	
		}else{
			HisVerStr = HisVerStr + "," + 	hospitalArrNew[j]["DicCode"];		
		}
	}
	var InputJson = {
		"HISVer":HisVerStr	
	}
	var RowId=indicatordef.Rowid;
	var savecode=tkMakeServerCall(GV.CKRCLASSNAME,"UpdaeByJson",JSON.stringify(InputJson),RowId);
	if(savecode!=0){
		$.messager.alert('提示','授权失败!','info'); 
		return;	
	}else{	
		$.messager.alert('提示','授权成功!','info'); 
	}
	//changeHospital(indicatordef);//院区前面修改图标要重新加载
	var indexrow=$('#ckDet').datagrid('getRowIndex',indicatordef);
	//alert(indicatordef['Name'])
	$('#ckDet').datagrid('updateRow',{
		index: indexrow,
		row: {
			HISVer: HisVerStr,
			Name: indicatordef['Name']
		}
	}); */
}

function btnSaveBak(){
	var indicatordef=$('#ckDet').datagrid('getSelected');
	if(typeof(indicatordef)=="undefined"||indicatordef==null)
	{
		$.messager.alert('提示', "请先选择指标!", "info", function() {
			});
		return;	
	}
	var hospitalArrNew=$('#dg').datagrid('getChecked');
	if(hospitalArrNew.length=="0")
	{
		$.messager.alert('提示', "请至少选择一个版本号!", "info", function() {
			});
		return;	
	}
	
	for(j=0;j<hospitalArrNew.length;j++)
	{
		var IsSave=true;
		for(i=0;i<hospitalArr.length;i++)
		{
			if(hospitalArr[i]["HosDr"]==hospitalArrNew[j]["HOSPRowId"])
			{IsSave=false;break;}
		}
		if(!IsSave){continue}
		var Code =indicatordef["Code"];
		var Name = indicatordef["Name"];
		var IndicatorTypeId = indicatordef["IndicatorTypeId"];
		var CheckType =indicatordef["CheckType"];
		var EXlevelId = indicatordef["EXlevelId"];
		var Description =  indicatordef["Description"];
		var ActiveFlag = indicatordef["ActiveFlag"];
		var ExecClass = indicatordef["ExecClass"];
		var ExecClassMethod =indicatordef["ExecClassMethod"];
		var HospDr = hospitalArrNew[j]["HOSPRowId"];
		var CRTER = indicatordef["CRTER"];
		var CRTEDATE = indicatordef["CRTEDATE"];
		var CRTETIME = indicatordef["CRTETIME"];
		var UPDTID =indicatordef["UPDTID"];
		var UPDTDATE =indicatordef["UPDTDATE"];
		var UPDTTIME =indicatordef["UPDTTIME"];
		var BusinessTypeCode =indicatordef["BusinessTypeCode"];
		selRowid = "";
		var saveinfo=selRowid+"^"+Code+"^"+Name+"^"+IndicatorTypeId+"^"+CheckType+"^"+EXlevelId+"^"+Description+"^"+ActiveFlag+"^"+ExecClass+"^"+ExecClassMethod+"^"+HospDr+"^"+CRTER+"^"+CRTEDATE+"^"+CRTETIME+"^"+UPDTID+"^"+UPDTDATE+"^"+UPDTTIME;
		saveinfo = saveinfo + "^" + BusinessTypeCode;
		saveinfo=saveinfo.replace(/请输入信息/g,"")
		var savecode=tkMakeServerCall(GV.CKRCLASSNAME,"Save",saveinfo,session['LOGON.USERID'])
		if(savecode.split("^")[0]<=0){
			$.messager.alert('提示','院区代码:'+hospitalArrNew[j]["HOSPRowId"]+'授权失败!rtn=' + savecode,'info');  
			return; 
		}
	}
	//删除未勾选的指标
	for(i=0;i<hospitalArr.length;i++)
	{
		var IsDelete=true;
		for(j=0;j<hospitalArrNew.length;j++)
		{
			if(hospitalArr[i]["HosDr"]==hospitalArrNew[j]["HOSPRowId"])
			{IsDelete=false;break;}
		}
		if(IsDelete)
		{
			var savecode=tkMakeServerCall(GV.CKRCLASSNAME,"Delete",hospitalArr[i]["Rowid"]);
			if(eval(savecode)!=0){
					$.messager.alert('提示', '院区代码:'+hospitalArrNew[j]["HOSPRowId"]+"取消授权失败!", "info", function() {
				});
				return;	
			}
		}
	}
	$.messager.alert('提示','授权成功!','info'); 
	changeHospital(indicatordef);//院区前面修改图标要重新加载
	var indexrow=$('#ckDet').datagrid('getRowIndex',indicatordef);
	$('#ckDet').datagrid('refreshRow',indexrow); //刷新行,修改院区后指标名称前面数字要改变
	
}
function indicatorEditClick(index){
	var ExtJsonObj = $('#ckDet').datagrid('getData').rows[index];
	IndicatorRowid=ExtJsonObj["Rowid"];
	setValueById('Code',ExtJsonObj["Code"]);
	setValueById('Name',ExtJsonObj["Name"]);
	setValueById('IndicatorTypeId',ExtJsonObj["IndicatorTypeId"]);
	setValueById('CheckType',ExtJsonObj["CheckType"]);
	setValueById('EXlevelId',ExtJsonObj["EXlevelId"]);
	setValueById('Description',ExtJsonObj["Description"]);
	setValueById('ActiveFlag',ExtJsonObj["ActiveFlag"]);
	setValueById('ExecClass',ExtJsonObj["ExecClass"]);
	setValueById('ExecClassMethod',ExtJsonObj["ExecClassMethod"]);
	setValueById('BusinessTypeCode',ExtJsonObj["BusinessTypeCode"]);
	$('#dhcinsutarEdit').window("open");
}



function DetailSave()
{		
	var Code =getValueById("Code");
	var Name = getValueById("Name");
	var IndicatorTypeId =getValueById("IndicatorTypeId");
	var CheckType =getValueById("CheckType");
	var EXlevelId = getValueById("EXlevelId");
	var Description = getValueById("Description");
	var ActiveFlag =getValueById("ActiveFlag");
	var ExecClass =getValueById("ExecClass");
	var ExecClassMethod =getValueById("ExecClassMethod");
	var HospDr = getValueById("HOSPRowId");
	var BusinessTypeCode =getValueById("BusinessTypeCode");
	var selRowid = IndicatorRowid;
	var saveinfo=selRowid+"^"+Code+"^"+Name+"^"+IndicatorTypeId+"^"+CheckType+"^"+EXlevelId+"^"+Description+"^"+ActiveFlag+"^"+ExecClass+"^"+ExecClassMethod+"^"+HospDr+"^"+"^"+"^"+"^"+"^"+"^";
	saveinfo = saveinfo + "^" + BusinessTypeCode;
	saveinfo=saveinfo.replace(/请输入信息/g,"")
	var savecode=tkMakeServerCall(GV.CKRCLASSNAME,"Save",saveinfo,session['LOGON.USERID'])
	if(savecode.split("^")[0]<=0){
		$.messager.alert('提示','保存失败!rtn=' + savecode,'info');  
		return; 
	}
	else
	{
		$.messager.alert('提示','保存成功!','info'); 
		$('#dhcinsutarEdit').window("close");
		loadConfPage();
	}
}

function init_CheckTypeCB(HosDR){
	$HUI.combobox("#CheckType", {
		panelHeight: 150,
		url: $URL,
		editable: false,
		valueField: 'DicCode',
		textField: 'DicDesc',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.DC.BL.DicDataCtl";
			param.QueryName = "QueryInfo";
			param.HospID =HosDR;
			param.KeyCode="";
			param.PDicType= "CheckType";
			param.ExpStr= "";
			param.ResultSetType = 'array';
			return true;
		},
		onLoadSuccess: function (data) {
			if (data.length > 1) {
				$(this).combobox("select", data[0].DicCode);
			}
		},
		onChange:function(val){
		}
	});
}
function init_BusinessTypeIdCB(HosDR){
	$HUI.combobox("#BusinessTypeCode", {
		panelHeight: 150,
		url: $URL,
		editable: false,
		valueField: 'DicCode',
		textField: 'DicDesc',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.DC.BL.DicDataCtl";
			param.QueryName = "QueryInfo";
			param.HospID =HosDR;
			param.KeyCode="";
			param.PDicType= "BusinessTypeCode";
			param.ResultSetType = 'array';
			return true;
		},
		onLoadSuccess: function (data) {
			if (data.length > 1) {
				$(this).combobox("select", data[0].DicCode);
			}
		},
		onSelect:function(){
		}
	});
}
function init_EXlevelIdCB(HosDR){
	$HUI.combobox("#EXlevelId", {
	panelHeight: 150,
	url: $URL,
	editable: false,
	valueField: 'DicCode',
	textField: 'DicDesc',
	defaultFilter: 4,
	onBeforeLoad: function (param) {
		param.ClassName = "BILL.DC.BL.DicDataCtl";
		param.QueryName = "QueryInfo";
		param.HospID =HosDR;
		param.KeyCode="";
		param.PDicType= "ExceptionLevel";
		param.ExpStr= "";
		param.ResultSetType = 'array';
		return true;
	},
	onLoadSuccess: function (data) {
		if (data.length > 1) {
			$(this).combobox("select", data[0].DicCode);
		}
	}
	});
}
function init_ActiveFlagCB(HosDR){
	$HUI.combobox("#ActiveFlag", {
		panelHeight: 150,
		valueField: 'DicCode',
		textField: 'DicDesc',
		defaultFilter: 4,
		data:[{DicCode:"Y",DicDesc:"是"},{DicCode:"N",DicDesc:"否"}],
		onSelect: function (data) {
		}
	});
}
function init_IndicatorTypeIdCB(HosDR){
	$HUI.combobox("#IndicatorTypeId", {
		panelHeight: 150,
		url: $URL,
		editable: false,
		valueField: 'DicCode',
		textField: 'DicDesc',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.DC.BL.DicDataCtl";
			param.QueryName = "QueryInfo";
			param.HospID =HosDR;
			param.KeyCode="";
			param.PDicType= "IndiType";
			param.ResultSetType = 'array';
			return true;
		},
		onLoadSuccess: function (data) {
			if (data.length > 1) {
				$(this).combobox("select", data[0].DicCode);
			}
		}
	});
}

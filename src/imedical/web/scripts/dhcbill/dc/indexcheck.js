/**
 * FileName: dhcbill.dc.indexcheck.js
 * Author: zjb
 * Date: 2022-05-31
 * Description: 指标核查结果
 */
 
var GV = {
	CLASSNAME:"BILL.DC.BL.DicDataCtl",
	CKRCLASSNAME:"BILL.DC.BL.IndicatorDefCtl",
	CKRDCLASSNAME:"BILL.DC.BL.CheckResultDetCtl"
};
var dgChoose='';
var DicActiveFlagList=[]; //是否有效字典
$(function() {
	var tableName = "User.INSUTarContrast";
	var defHospId =  session['LOGON.HOSPID'];//
	$("#hospital").combobox({
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBL.BDP.BDPMappingHOSP&QueryName=GetHospDataForCombo&ResultSetType=array&tablename=' + tableName,
		method: 'GET',
		valueField: 'HOSPRowId',
		textField: 'HOSPDesc',
		editable: false,
		blurValidValue: true,
		onLoadSuccess: function(data) {
			$(this).combobox('select', defHospId);
		},
		onChange: function(newValue, oldValue) {
			var HISVer = tkMakeServerCall("BILL.DC.BL.DicDataCtl","GetDicInfoByTypeCode","SYS", "HISVer", newValue,"14");
			setValueById('HISVer',HISVer);
			loadDG();
		}
	});

	getDicActiveFlagList();
	
	$("#search").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			loadDG();
		}
	});
	$("#search1").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			loadConfPage();
		}
	});


	//GV.MontList = $HUI.datagrid("#montList", {
	GV.MontList = $HUI.datagrid("#dg", {
		idField:'Rowid',
    	//treeField:'CheckBatch',
		//animate: true,
		//onContextMenu: onContextMenuHandler,
		//
		fit: true,
		border: false,
		singleSelect: false, //设置为 true，则只允许选中一行。
		checkOnSelect:false,// true，当用户点击某一行时，则会选中/取消选中复选框。 false 时，只有当用户点击了复选框时，才会选中/取消选中复选框。
		selectOnCheck:false,// true，点击复选框将会选中该行。 false，选中该行将不会选中复选框。
		//fitColumns: true,
		pagination: false,
		pageSize: 20,
		displayMsg: '',
		// IndicatorId,IndicatorCode,IndicatorName,CheckMode,CheckStartDate,CheckStartTime,CheckEndDate,CheckEndTime,CheckFlag,HospDr,CRTER,CRTEDATE,CRTETIME,UPDTID,UPDTDATE,UPDTTIME,Rowid,CheckBatch,ExceptionNum
		columns: [[
			{title: '选择', field: ' CheckOrd',checkbox:true, width: 50,tipPosition:"top",showTip:true},
			{title: '指标分类名称', field: 'DicDesc', width: 175,tipPosition:"top",showTip:true},
			{title: '指标分类方法', field: 'DicDemo', width: 300,tipPosition:"top",showTip:true,hidden:true}

		]],
		onLoadSuccess: function(data) {
			GV.MontList.unselectAll();
		},
		onSelect: function(index, row) {
			if (dgChoose===''||dgChoose===index)
			{
				dgChoose=index;
			}
			else
			{
				GV.MontList.unselectRow(dgChoose);
				dgChoose=index;
			}
			$('#search1').val('');
			loadConfPage(row.DicCode);
		},
		onLoadError:function(a){
			//alert(2)
		},
	   	onSelectRow: function () {
                selectedRowIndex = $("#" + this.id).getGridParam('selrow');
                $("#delProducts").attr("selectedIndex", selectedRowIndex);
        },
		onCheck:function(rowIndex,rowData){
			if(rowData.DicType=='AllIndex')
			{
				$('#dg').datagrid('uncheckRow',rowIndex);
			}
		}//,
		/* onCheckAll:function(rows){
			for(var i=0; i<rows.length;i++)
			{
				if(rows[i].DicType=='AllIndex')
				{
					$('#dg').datagrid('uncheckRow',i);
				}
			}
		} */
	});
	

	init_ckDetDG();
	$('#btnFind1').attr("disabled",false);
	$('#btnFind').attr("disabled","disabled");
	$('#StartDT').datebox({
		onSelect:function(date){
			var daydiff=DateDiff(getDefStDate(-1),date)
			if(daydiff>0){
				$.messager.alert('提示','起始时间必须小于T。','info');
				setValueById('EndDT',getDefStDate(-1));
				setValueById('StartDT',getDefStDate(-1));
				return ;
			}
			else
			{
				setValueById('EndDT',getDefStDate(daydiff-1));
			} 
		}	
	})
 	$('#EndDT').datebox({
		onSelect:function(date){
			var daydiff=DateDiff(getValueById('StartDT'),date)
			if(daydiff>0){
				$.messager.alert('提示','时间跨度太长!。','info');
				setValueById('EndDT',getValueById("StartDT"));
				return;
			}
			if(daydiff<0){
				$.messager.alert('提示','结束时间不能小于起始时间!。','info');
				setValueById('EndDT',getValueById("StartDT"));
				return;
			} 	
		}	
	}) 
	setValueById('StartDT',getDefStDate(-1));
	setValueById('EndDT',getDefStDate(-1));
	//loadDG();
});
function loadDG(){
	$("#ckDet").datagrid('unselectAll')
	$('#ckDet').datagrid('loadData',{total:0,rows:[]});
	$("#dg").datagrid('unselectAll')
	$('#dg').datagrid('loadData',{total:0,rows:[]});
	// tangzf 2020-6-17 使用HISUI接口 加载数据
	/* var QueryParam={
		ClassName: GV.CLASSNAME,
		QueryName: 'QueryInfo',
		HospID : "G",//PUBLIC_CONSTANT.SESSION.HOSPID,
		KeyCode:getValueById('search'),
		PDicType:"CheckType"//$('#diccbx').combobox('getValue')==""?"SYS":$('#diccbx').combobox('getValue')
	}
	loadDataGridStore('dg',QueryParam); */
 	$.cm({
		ClassName: GV.CLASSNAME,
		QueryName: 'QueryInfo',
		HospID : "G",//PUBLIC_CONSTANT.SESSION.HOSPID,
		KeyCode:getValueById('search'),
		PDicType:"CheckType",//$('#diccbx').combobox('getValue')==""?"SYS":$('#diccbx').combobox('getValue')
		rows:9999
	},function(Data){	
		var AllIndex={
			ActiveFlag: "N",
			CRTEDATE: "",
			CRTER: "1",
			CRTETIME:"",
			ConCode:"",
			ConDemo:"",
			ConDesc:"所有指标",
			DicCode:"",
			DicDemo:"",
			DicDesc:"所有指标(勾选不参与核查)",
			DicNum:"0",
			DicType:"AllIndex",
			HospDr:"G",
			Rowid:"",
			UPDTDATE:"",
			UPDTID:"",
			UPDTTIME:""
		}
		Data.rows.unshift(AllIndex);
		$('#dg').datagrid('loadData',Data);
	}); 
}
function init_ckDetDG(){
	GV.ckDet =$HUI.datagrid("#ckDet", {
		fit: true,
		border: false,
		singleSelect: false,
		//pagination: true,
		//pageSize: 20,
		striped:true,
		//toolbar: '#dgTB',
		displayMsg: '',
		idField: 'Rowid',
		// IndicatorId,IndicatorCode,IndicatorName,CheckMode,CheckStartDate,CheckStartTime,CheckEndDate,CheckEndTime,CheckFlag,HospDr,CRTER,CRTEDATE,CRTETIME,UPDTID,UPDTDATE,UPDTTIME,Rowid,CheckBatch,ExceptionNum
		columns: [[
			{title:'选择', field: 'CheckOrd',checkbox:true, width: 50,tipPosition:"top",showTip:true},
			{field:'Code',title:'指标代码',width:80,hidden:true},
			{field:'Name',title:'指标名称',width:580,tipPosition:"top",showTip:true},
			{field:'CheckType',title:'核查分类',width:180,hidden:true},
			{field:'BusinessTypeCode',title:'指标业务类型代码',width:180,hidden:true},
			{field:'BusinessTypeDesc',title:'指标业务类型描述',width:80,tipPosition:"top",showTip:true,hidden:true},
			{field:'ExecClass',title:'执行类名',width:120,hidden:true},
			{field:'ExecClassMethod',title:'类方法名',width:350,tipPosition:"top",showTip:true,hidden:true},
			{field:'IndicatorTypeId',title:'指标类型',width:80,hidden:true//,
				/* formatter: function (value, row, index) {
					var rtn = tkMakeServerCall("BILL.DC.BL.DicDataCtl","GetDicInfoByTypeCode","IndiType", value, getValueById('hospital'),"2");
					return rtn=="" ? value : rtn;
				} */
			},
			{field:'ActiveFlag',title:'是否有效',width:80,
				formatter: function (value, row, index) {
					//var rtn = tkMakeServerCall("BILL.DC.BL.DicDataCtl","GetDicInfoByTypeCode","ActiveFlag", value, "G","2");
					var rtn="";
					for (var i=0;i<DicActiveFlagList.length;i++)
					{
						if(DicActiveFlagList[i].DicCode==value)
						{
							rtn=DicActiveFlagList[i].DicDesc;
							break;
						}
					}
					return (value == "Y") ? rtn : "<font color='#f16e57'>" + rtn +"</font>";
			}},
			{field:'EXlevelId',title:'异常等级',width:80,hidden:true},
			{field:'Description',title:'监控点说明',tipPosition:"top",showTip:true,hidden:true},
			{field:'HospDr',title:'院区',width:50,width:10,hidden:true},
			{field:'CRTER',title:'创建人',width:50,width:10,hidden:true},
			{field:'CRTEDATE',title:'创建日期',width:50,width:10,hidden:true},
			{field:'CRTETIME',title:'创建时间',width:50,width:10,hidden:true},
			{field:'UPDTID',title:'更新人',width:50,width:10,hidden:true},
			{field:'UPDTDATE',title:'更新日期',width:50,width:10,hidden:true},
			{field:'UPDTTIME',title:'更新时间',width:50,width:10,hidden:true},
			{field:'Rowid',title:'Rowid',width:10,hidden:true}
			]],
		onLoadSuccess: function(data) {
			GV.ckDet.unselectAll();
		},
		onSelect: function(index, row) {
		}
		
	});
}


function loadConfPage(CheckType) {
	$("#ckDet").datagrid('unselectAll')
	$('#ckDet').datagrid('loadData',{total:0,rows:[]});
	//var SearchWords=$("#search1").val();
	var queryParams = {
		ClassName: GV.CKRCLASSNAME,
		QueryName: "QueryInfo",
		HospID:getValueById('hospital'),//PUBLIC_CONSTANT.SESSION.HOSPID,
		KeyCode:getValueById('search1'),//SearchWords,
		PCheckType:CheckType,
		QHISVer:""+getValueById('HISVer'),	
		QExceptionLeval:'',
		QBusinessType:'',
		PCheckFlag:'Y',
		rows:9999
		//ParentID: GV.MontList.getSelected().Rowid,
		//KeyCode:getValueById('search1'),
		//PCheckFlag:""//(getValueById('CheckFlag')=="true"?"Y":"N")
	}
	//alert((getValueById('CheckFlag')=="true"?"Y":"N"))
	loadDataGridStore("ckDet", queryParams);
}

//获取字典是否有效集合
function getDicActiveFlagList(){
	var ExtJsonStr = $.cm({
		ClassName: "BILL.DC.BL.DicDataCtl",
		QueryName: "QueryInfo",
		ResultSetType:"array",
		HospID:"G",
		PDicType:"ActiveFlag"
	}, false);
	if(ExtJsonStr.length){
		for(var i=0;i<ExtJsonStr.length;i++)
		{
			var obj={};
			obj.DicCode=ExtJsonStr[i].DicCode;
			obj.DicDesc=ExtJsonStr[i].DicDesc;
			DicActiveFlagList.push(obj);	
		}
	}
}

//按分类核查
function DoCheckBySort(){
	
	var StartDT=$("#StartDT").datetimebox('getValue')
	var EndDT=$("#EndDT").datetimebox('getValue')
	if (StartDT==""||EndDT==""){
		$.messager.alert('提示','请选择核查起止时间。','info');
		return;
	}
	//var startDate=getValueById('StartDT');//.split(' ')[0];
	//var EndDate=getValueById('EndDT');
	//var endDT=document.getElementById('EndDT').innerHTML;
//	var StartDate=StartDT.split(' ')[0];//getValueById('StartDate');
//	var StrTime=StartDT.split(' ')[1];
//	var EndDate=EndDT.split(' ')[0];//getValueById('EndDate');
//	var EndTime=EndDT.split(' ')[1];
	var ckRows =  $('#dg').datagrid('getChecked');
	
	if (ckRows.length==0)
	{
		$.messager.alert('提示','请勾选需要核查的指标分类名称。','info');
		return;
	}
	var IndicatorCodeStr='';
	var HospDr=getValueById('hospital');
	var CheckType='';
	var CheckMode="S";
	var UserId= session['LOGON.USERCODE'];//"demo";
	$.messager.confirm('提示','是否继续操作' + ckRows.length + '条数据？',function(r){
		if(r){
			//设置按钮不可用
			$('#btnFind1').linkbutton({disabled:true});
			$('#btnFind').linkbutton({disabled:true});
	
			//var getRows = $('#ckDet').datagrid('getRows');
			for (var i=0;i<ckRows.length;i++){
				var row = ckRows[i];
				var ActiveFlag = row['ActiveFlag'];
				if (ActiveFlag=="Y")
				{
					if(i==0)
					{
						CheckType=row['DicCode'] + "^";
					}
					else
					{
						CheckType=CheckType + row['DicCode'] + "^";	
					}
				}
			}
			if(CheckType.length>0)
			{
				CheckType=CheckType.substr(0,CheckType.length-1);
			}
			/* var rtn = tkMakeServerCall("BILL.DC.Check","Check",StartDate,EndDate,StrTime,EndTime,CheckType,HospDr,CheckMode,IndicatorCodeStr,UserId);	
			if (rtn==""){
					$('#btnFind1').linkbutton({disabled:false});
					$('#btnFind').linkbutton({disabled:false});	 
					$.messager.alert('提示','核查成功','info');
			} */
			
			$.messager.popover({
				msg: '正在核查,请耐心等候！',
				type: 'success',
				timeout: 2000, 		//0不自动关闭。3000s
				showType: 'slide'  //show,fade,slide
			});
			
			$.cm({
				ClassName:"BILL.DC.Check",
				MethodName:"Check",
				StartDate:StartDT,
				EndDate:EndDT,
				StartTime:'',
				EndTime:'',
				CheckType:CheckType,
				HospDr:HospDr,
				CheckMode:CheckMode,
				IndicatorCodeStr:IndicatorCodeStr,
				UserId:UserId,
				dataType:'text'
			},function(txtData){
				$('#btnFind1').linkbutton({disabled:false});
				$('#btnFind').linkbutton({disabled:false});		
				if (txtData==""){
					$.messager.alert('提示','核查成功','info');
				}else{
					$.messager.alert('警告',txtData,'info');
				}
			
			});  
		
		}
		
	});
}

function DateDiff(sDate, eDate) {
	var date1 = new Date(sDate);
	var date2 = new Date(eDate);
	var date3=date2.getTime()-date1.getTime();
	var days=Math.floor(date3/(24*3600*1000));
	return days+1;
}

//按指标核查
function DoCheckByIndex(){
	var StartDT=$("#StartDT").datetimebox('getValue')
	var EndDT=$("#EndDT").datetimebox('getValue')
	if (StartDT==""||EndDT==""){
		$.messager.alert('提示','请选择核查起止时间。','info');
		return;
	}
	//var startDate=getValueById('StartDT');//.split(' ')[0];
	//var EndDate=getValueById('EndDT');
	//var endDT=document.getElementById('EndDT').innerHTML;
	var ckRows =  $('#ckDet').datagrid('getChecked');
	
	if (ckRows.length==0)
	{
		$.messager.alert('提示','请选择核查指标。','info');
		return;
	}
	var IndicatorCodeStr='{';
	var HospDr=getValueById('hospital');
	var CheckType="";//ckRows[0].CheckType;
	var CheckMode="S";
	var UserId=session['LOGON.USERCODE'];//"demo";
	$.messager.confirm('提示','是否继续操作' + ckRows.length + '条数据？',function(r){
		if(r){
			//设置按钮不可用
			$('#btnFind1').linkbutton({disabled:true});
			$('#btnFind').linkbutton({disabled:true});
	
			//var getRows = $('#ckDet').datagrid('getRows');
			//组装IndicatorCodeStr,jsonstring格式：{checktype1:指标1^指标2,checktype2:指标1^指标2}
			var CheckTypelist="^";
			for (var i=0;i<ckRows.length;i++){
				var row = ckRows[i];
				if(CheckTypelist.indexOf(row.CheckType)!='-1')//过滤重复的checktype
				{
					continue;
				}
				else
				{
					CheckTypelist+=row.CheckType+"^";
					var CheckTypeIndex='"'+row.CheckType+'":"';
					for(var j=0;j<ckRows.length;j++){
						var RowItem=ckRows[j];
						var ActiveFlag = RowItem['ActiveFlag'];
						if (ActiveFlag=="Y" && row.CheckType==RowItem.CheckType)//组装指标code
						{
							CheckTypeIndex=CheckTypeIndex+RowItem['Code']+"^";	
						}
					}
					if(CheckTypeIndex.length>0){
						CheckTypeIndex=CheckTypeIndex.substr(0,CheckTypeIndex.length-1);
						IndicatorCodeStr+=CheckTypeIndex+'",';
					}
				}
			}
			if(IndicatorCodeStr.length>1)
			{
				IndicatorCodeStr=IndicatorCodeStr.substr(0,IndicatorCodeStr.length-1);
				IndicatorCodeStr+='}';
			}
			/* var rtn = tkMakeServerCall("BILL.DC.Check","Check",StartDate,EndDate,StrTime,EndTime,CheckType,HospDr,CheckMode,IndicatorCodeStr,UserId);	
			if (rtn==""){
				$('#btnFind1').linkbutton({disabled:false});
				$('#btnFind').linkbutton({disabled:false});		
				$.messager.alert('提示','核查成功','info');
			} */
			$.messager.popover({
				msg: '正在核查,请耐心等候！',
				type: 'success',
				timeout: 1500, 		//0不自动关闭。3000s
				showType: 'slide'  //show,fade,slide
			});
			
			$.cm({
				ClassName:"BILL.DC.Check",
				MethodName:"Check",
				StartDate:StartDT,
				EndDate:EndDT,
				StartTime:'',
				EndTime:'',
				CheckType:CheckType,
				HospDr:HospDr,
				CheckMode:CheckMode,
				IndicatorCodeStr:IndicatorCodeStr,
				UserId:UserId,
				dataType:'text'
			},function(txtData){
				$('#btnFind1').linkbutton({disabled:false});
				$('#btnFind').linkbutton({disabled:false});		
				if (txtData==""){
					$.messager.alert('提示','核查成功','info');
				}else{
					$.messager.alert('警告',txtData,'info');
				}
				
			
			});  
			//loadConfPage();
			
		}
		
	});
}

function serverToHtml(str) {
	return str.toString().replace(/<br\/>/g, "\r\n").replace(/&nbsp;/g, " ");
}

function htmlToServer(str) {
	return str.toString().replace(/(\r)*\n/g, "<br/>").replace(/\s/g, "&nbsp;");
}
//审核
function Audit(){
		
}

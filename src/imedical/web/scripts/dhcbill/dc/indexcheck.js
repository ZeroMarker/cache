/**
 * FileName: dhcbill.dc.indexcheck.js
 * Author: zjb
 * Date: 2022-05-31
 * Description: ָ��˲���
 */
 
var GV = {
	CLASSNAME:"BILL.DC.BL.DicDataCtl",
	CKRCLASSNAME:"BILL.DC.BL.IndicatorDefCtl",
	CKRDCLASSNAME:"BILL.DC.BL.CheckResultDetCtl"
};
var dgChoose='';
var DicActiveFlagList=[]; //�Ƿ���Ч�ֵ�
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
		singleSelect: false, //����Ϊ true����ֻ����ѡ��һ�С�
		checkOnSelect:false,// true�����û����ĳһ��ʱ�����ѡ��/ȡ��ѡ�и�ѡ�� false ʱ��ֻ�е��û�����˸�ѡ��ʱ���Ż�ѡ��/ȡ��ѡ�и�ѡ��
		selectOnCheck:false,// true�������ѡ�򽫻�ѡ�и��С� false��ѡ�и��н�����ѡ�и�ѡ��
		//fitColumns: true,
		pagination: false,
		pageSize: 20,
		displayMsg: '',
		// IndicatorId,IndicatorCode,IndicatorName,CheckMode,CheckStartDate,CheckStartTime,CheckEndDate,CheckEndTime,CheckFlag,HospDr,CRTER,CRTEDATE,CRTETIME,UPDTID,UPDTDATE,UPDTTIME,Rowid,CheckBatch,ExceptionNum
		columns: [[
			{title: 'ѡ��', field: ' CheckOrd',checkbox:true, width: 50,tipPosition:"top",showTip:true},
			{title: 'ָ���������', field: 'DicDesc', width: 175,tipPosition:"top",showTip:true},
			{title: 'ָ����෽��', field: 'DicDemo', width: 300,tipPosition:"top",showTip:true,hidden:true}

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
				$.messager.alert('��ʾ','��ʼʱ�����С��T��','info');
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
				$.messager.alert('��ʾ','ʱ����̫��!��','info');
				setValueById('EndDT',getValueById("StartDT"));
				return;
			}
			if(daydiff<0){
				$.messager.alert('��ʾ','����ʱ�䲻��С����ʼʱ��!��','info');
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
	// tangzf 2020-6-17 ʹ��HISUI�ӿ� ��������
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
			ConDesc:"����ָ��",
			DicCode:"",
			DicDemo:"",
			DicDesc:"����ָ��(��ѡ������˲�)",
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
			{title:'ѡ��', field: 'CheckOrd',checkbox:true, width: 50,tipPosition:"top",showTip:true},
			{field:'Code',title:'ָ�����',width:80,hidden:true},
			{field:'Name',title:'ָ������',width:580,tipPosition:"top",showTip:true},
			{field:'CheckType',title:'�˲����',width:180,hidden:true},
			{field:'BusinessTypeCode',title:'ָ��ҵ�����ʹ���',width:180,hidden:true},
			{field:'BusinessTypeDesc',title:'ָ��ҵ����������',width:80,tipPosition:"top",showTip:true,hidden:true},
			{field:'ExecClass',title:'ִ������',width:120,hidden:true},
			{field:'ExecClassMethod',title:'�෽����',width:350,tipPosition:"top",showTip:true,hidden:true},
			{field:'IndicatorTypeId',title:'ָ������',width:80,hidden:true//,
				/* formatter: function (value, row, index) {
					var rtn = tkMakeServerCall("BILL.DC.BL.DicDataCtl","GetDicInfoByTypeCode","IndiType", value, getValueById('hospital'),"2");
					return rtn=="" ? value : rtn;
				} */
			},
			{field:'ActiveFlag',title:'�Ƿ���Ч',width:80,
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
			{field:'EXlevelId',title:'�쳣�ȼ�',width:80,hidden:true},
			{field:'Description',title:'��ص�˵��',tipPosition:"top",showTip:true,hidden:true},
			{field:'HospDr',title:'Ժ��',width:50,width:10,hidden:true},
			{field:'CRTER',title:'������',width:50,width:10,hidden:true},
			{field:'CRTEDATE',title:'��������',width:50,width:10,hidden:true},
			{field:'CRTETIME',title:'����ʱ��',width:50,width:10,hidden:true},
			{field:'UPDTID',title:'������',width:50,width:10,hidden:true},
			{field:'UPDTDATE',title:'��������',width:50,width:10,hidden:true},
			{field:'UPDTTIME',title:'����ʱ��',width:50,width:10,hidden:true},
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

//��ȡ�ֵ��Ƿ���Ч����
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

//������˲�
function DoCheckBySort(){
	
	var StartDT=$("#StartDT").datetimebox('getValue')
	var EndDT=$("#EndDT").datetimebox('getValue')
	if (StartDT==""||EndDT==""){
		$.messager.alert('��ʾ','��ѡ��˲���ֹʱ�䡣','info');
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
		$.messager.alert('��ʾ','�빴ѡ��Ҫ�˲��ָ��������ơ�','info');
		return;
	}
	var IndicatorCodeStr='';
	var HospDr=getValueById('hospital');
	var CheckType='';
	var CheckMode="S";
	var UserId= session['LOGON.USERCODE'];//"demo";
	$.messager.confirm('��ʾ','�Ƿ��������' + ckRows.length + '�����ݣ�',function(r){
		if(r){
			//���ð�ť������
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
					$.messager.alert('��ʾ','�˲�ɹ�','info');
			} */
			
			$.messager.popover({
				msg: '���ں˲�,�����ĵȺ�',
				type: 'success',
				timeout: 2000, 		//0���Զ��رա�3000s
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
					$.messager.alert('��ʾ','�˲�ɹ�','info');
				}else{
					$.messager.alert('����',txtData,'info');
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

//��ָ��˲�
function DoCheckByIndex(){
	var StartDT=$("#StartDT").datetimebox('getValue')
	var EndDT=$("#EndDT").datetimebox('getValue')
	if (StartDT==""||EndDT==""){
		$.messager.alert('��ʾ','��ѡ��˲���ֹʱ�䡣','info');
		return;
	}
	//var startDate=getValueById('StartDT');//.split(' ')[0];
	//var EndDate=getValueById('EndDT');
	//var endDT=document.getElementById('EndDT').innerHTML;
	var ckRows =  $('#ckDet').datagrid('getChecked');
	
	if (ckRows.length==0)
	{
		$.messager.alert('��ʾ','��ѡ��˲�ָ�ꡣ','info');
		return;
	}
	var IndicatorCodeStr='{';
	var HospDr=getValueById('hospital');
	var CheckType="";//ckRows[0].CheckType;
	var CheckMode="S";
	var UserId=session['LOGON.USERCODE'];//"demo";
	$.messager.confirm('��ʾ','�Ƿ��������' + ckRows.length + '�����ݣ�',function(r){
		if(r){
			//���ð�ť������
			$('#btnFind1').linkbutton({disabled:true});
			$('#btnFind').linkbutton({disabled:true});
	
			//var getRows = $('#ckDet').datagrid('getRows');
			//��װIndicatorCodeStr,jsonstring��ʽ��{checktype1:ָ��1^ָ��2,checktype2:ָ��1^ָ��2}
			var CheckTypelist="^";
			for (var i=0;i<ckRows.length;i++){
				var row = ckRows[i];
				if(CheckTypelist.indexOf(row.CheckType)!='-1')//�����ظ���checktype
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
						if (ActiveFlag=="Y" && row.CheckType==RowItem.CheckType)//��װָ��code
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
				$.messager.alert('��ʾ','�˲�ɹ�','info');
			} */
			$.messager.popover({
				msg: '���ں˲�,�����ĵȺ�',
				type: 'success',
				timeout: 1500, 		//0���Զ��رա�3000s
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
					$.messager.alert('��ʾ','�˲�ɹ�','info');
				}else{
					$.messager.alert('����',txtData,'info');
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
//���
function Audit(){
		
}

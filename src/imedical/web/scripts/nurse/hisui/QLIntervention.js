/**
* @author songchunli
* HISUI ����Դ�ʩ������js
* QLIntervention.js
*/
var PageLogicObj={
	m_tabQLInterventionEdit:"",
	m_selQLLIntRowID:"",
	m_WardJson:"",
	iframeflag:"0", //2758853������ƻ����á�ҵ���������  �Ƿ���iframe ����  1���ǣ� 0����
	selectQueRowID:""
}
$(function(){ 
	//2758853������ƻ����á�ҵ���������
	var iframeflag=""
	if (window.parent.window.PageLogicObj){
		iframeflag=window.parent.window.PageLogicObj.iframeflag
	}
	if(iframeflag=="1"){// iframe ����
		PageLogicObj.iframeflag=iframeflag
		Init();	   			
	}
	else if ((iframeflag== "")||(iframeflag=="0")){// ��������
		InitHospList();			
	}
	InitEvent();
});
$(window).load(function() {	
	InitQLInterventionEditWin();
	InitEditWindow();
	InitWardJson();
})
function InitEvent(){
 	$("#BFind").click(function(){
	 	$("#tabQLInterventionList").datagrid("reload");
	});
 	$("#BAddQLMeasures").click(AddQLMeasuresClick);
 	$("#searchName").keydown(searchNameOnKeyDown);
	$("#BSaveQLIntervention").click(SaveQLInterventionClick);
 	$("#BCancel").click(function(){
	 	$("#QLInterventionEditWin").window('close');
	});
}
function InitHospList(){
	var hospComp = GenHospComp("Nur_IP_QLIntervention");
	hospComp.jdata.options.onSelect = function(e,t){
		$("#searchName").val("");
		$("#tabQLInterventionList").datagrid("load");
		InitWardJson();
		InitQLInterventionEditWin();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
function Init(){
	InitStatus();
	InitQLRelateFactorListDataGrid();
}
function InitWardJson(){
	$.cm({
		ClassName:"Nur.NIS.Service.Base.Ward",
		QueryName:"GetallWardNew",
		desc:"",
		//hospid:$HUI.combogrid('#_HospList').getValue(),
		//2758853������ƻ����á�ҵ���������
		hospid:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue()),
		bizTable:"Nur_IP_QLIntervention",
		rows:99999
	},function(data){
		PageLogicObj.m_WardJson=data.rows;
	})
}
function ReloadIframe(){
	$("#iframeInterventions").attr('src', "nur.hisui.qlintervention.csp");
}
function InitStatus(){
	$("#status").combobox({
		width:'auto',
		valueField:'id',
		textField:'text',
		mode: "local",
		multiple:true,
		rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
		data:[{"id":"1","text":"����",selected:true},{"id":"0","text":"ͣ��"}],
		onSelect:function(rec){
			if (rec) {
				$("#tabQLInterventionList").datagrid("load");
			}
		}
	});
}
//2758853������ƻ����á�ҵ���������
function ResetQLInterventionEditWin(){
	var iframeHeight= parseInt($("#main-div").css("height"))
	var iframeWidth= parseInt($("#main-div").css("width"))
	if (PageLogicObj.iframeflag=="1"){
		$("#QLInterventionEditWin").parent().css({
			width:iframeWidth,
		});
		$("#QLInterventionEditWin").parent().find(".panel-header").css({
			width:iframeWidth,
		});
		$("#QLInterventionEditWin").css({
			height:iframeHeight-40,
			width:iframeWidth,
		});
		$("#search-table-panel").css({
			width:iframeWidth-22,
		});
		$("#NursingMeasures").css({width:iframeWidth-150});
    	/*
		$("#intervention-layout").layout("resize").layout('panel', 'center').panel('resize', {
	        width: iframeWidth-30,

    	});	    	
    	$("#tabQLInterventionEdit").datagrid("resize",{
	    	width:'98%',
	    	height:'98%'
	    });
	    */

    }
	
}
function InitQLRelateFactorListDataGrid(){
	var ToolBar = [{
            text: '����',
            iconCls: 'icon-add',
            handler: function() {
	            //2758853������ƻ����á�ҵ���������
	            if (PageLogicObj.iframeflag=="1"){
		            var qrow =$(window.parent.$("#iframeQuestion"))[0].contentWindow.$("#tabQuestionList").datagrid("getSelected");
		        	if (!qrow){
						$.messager.popover({msg:'��ѡ��һ���������⣡',type:'error'});
						return false;
					}
					InitQuestion();
					$("#Question").combobox("setValue",qrow.rowID);
					$("#QuestionType").val(qrow.careTypeT);
					$("#QuestionCode").val(qrow.queCode);
					var applyAreaStr=eval("("+qrow.applyAreaDescStr+")").join("��");
					InittabQLInterventionEdit();
					/*
					var row = $("#tabQLInterventionList").datagrid('getRows')[0];
					if(row){
						SetQLInterventionRowData(row);						
						var applyAreaStr=eval("("+row.applyAreaStr+")").join("��");
					}else{
						InitQuestion();
						$("#Question").combobox("setValue",qrow.rowID);
						$("#QuestionType").val(qrow.careTypeT);
						$("#QuestionCode").val(qrow.queCode);
						var applyAreaStr=eval("("+qrow.applyAreaDescStr+")").join("��");
						InittabQLInterventionEdit();
					}
					*/
					//�������3084983
					$('#RelateFactor').combobox("reload",rewriteUrl($('#RelateFactor').combobox("options").url, {queID:qrow.rowID}));
					if (!applyAreaStr) applyAreaStr="ȫԺ";
					$("#QuestionApplyArea").val(applyAreaStr);							
					ResetQLInterventionEditWin();
				    $("#QLInterventionEditWin").window('open');	        
		        }
		        else{
				    PageLogicObj.m_selQLLIntRowID="";
					// ���²�ѯ �������⻺�� 2021.7.6
		            InitQuestion();
				    $("#QLInterventionEditWin").window('open');
		            $("#Question").next('span').find('input').focus();
			    }            
			}
        },{
            text: '�޸�',
            iconCls: 'icon-write-order',
            handler: function() {
	            var selected = $("#tabQLInterventionList").datagrid("getSelected");
				if (!selected) {
					$.messager.alert("��ʾ","��ѡ����Ҫ�޸ĵļ�¼��");
					return false;
				}
				ResetQLInterventionEditWin();  //2758853������ƻ����á�ҵ���������
				SetQLInterventionRowData(selected);
				$("#QLInterventionEditWin").window('open');
            }
        },{
            text: 'ɾ��',
            iconCls: 'icon-cancel',
            handler: function() {
                var selected = $("#tabQLInterventionList").datagrid("getSelected");
				if (!selected) {
					$.messager.alert("��ʾ","��ѡ��һ����¼��");
					return false;
				}
				var Msg="ȷ��Ҫɾ�����������ʩ��";
					Msg += '</br><sapn style="opacity:0.65;">�˻����ʩɾ���󣬻������⽫�����Զ������û����ʩ��</sapn>';
				$.messager.confirm('��ʾ', Msg, function(r){
					if (r) {
						var recordID=selected.recordID;
						if (recordID) {
							var rtn=$.m({
								ClassName:"Nur.NIS.Service.NursingPlan.InterventionSetting",
								MethodName:"DeleteIntervention",
								locID:session['LOGON.CTLOCID'],
								userID:session['LOGON.USERID'],
								recordID:recordID
							},false)
							if (rtn !=0) {
								$.messager.popover({msg:'ɾ��ʧ�ܣ�',type:'error'});
								return false;
							}else{
								$.messager.popover({msg:'ɾ���ɹ���',type:'success'});
							}
							$('#tabQLInterventionList').datagrid('reload');
						}
					}
				});
            }
        },{
	        id:'InterventionCopy',
	        text: '����',
			iconCls: 'icon-copy',
			handler: function(){
				var selected = $("#tabQLInterventionList").datagrid("getSelected");
				if (!selected) {
					$.messager.popover({msg:'��ѡ����Ҫ���Ƶļ�¼��',type:'error'});
					return false;
				}
				SetQLInterventionRowData(selected);
				$("#QLInterventionEditWin").window('open');
				PageLogicObj.m_selQLLIntRowID="";
			}
	}];
	var Columns=[[    		
		{ field: 'queCode',title:'�������',width:100},
		{ field: 'queName', title: '��������',width:150,wordBreak:"break-all"},
		{ field: 'careTypeT',title:'�������',width:200,wordBreak:"break-all"},
		{ field: 'intType', title: '��ʩ����',width:100,
			formatter: function(value,row,index){
				return value.split("^")[1]+"("+value.split("^")[2]+")";
			}
		},
		{ field: 'intCode', title: '��ʩ����',width:90},
		{ field: 'intShortName', title: '��ʩ������',width:320,wordBreak:"break-all"},
				{ field: 'reasonStr', title: '�������',width:120,wordBreak:"break-all"},		
		{ field: 'intStatus', title: '״̬',width:60,
			styler: function(value,row,index){
				if (value =="����"){
					return "color:#3FBD79;"
				}else{
					return "color:#F16E57;"
				}
			}
		},
		{ field: 'applyAreaStr', title: '�������÷�Χ',width:120,
			formatter: function(value,row,index){
				value=eval("("+value+")").join("��");
				if (!value) value="ȫԺ";
				return value;
			}
		},

    ]];
	$('#tabQLInterventionList').datagrid({  
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		width : 'auto',
		fitColumns : false,
		loadMsg : '������..',  
		pagination : true, 
		rownumbers : true,
		idField:"recordID",
		pageSize: 15,
		pageList : [15,50,100,200],
		columns :Columns,
		toolbar :ToolBar,
		autoRowHeight:true,
		nowrap:false,  /*�˴�Ϊfalse*/
		url : $URL+"?ClassName=Nur.NIS.Service.NursingPlan.InterventionSetting&QueryName=FindInterventionList",
		onBeforeLoad:function(param){
			try{
				var qRowId=window.parent.window.iframeQuestion.PageLogicObj.m_SelRowId;
			}catch(err){
				qRowId=""
			}
			PageLogicObj.m_selQLLIntRowID="";
			$('#tabQLInterventionList').datagrid("unselectAll");
			var status=$("#status").combobox('getValues');
			if (status.length ==1){
				status=status.join("");
			}else{
				status="-1";
			}
			param = $.extend(param,{
				searchName:$("#searchName").val(),
				status:status,
				//searchQueRowID:'',      //������ע�ͣ�����㻤�����ⲻ�����̨����
				searchQueRowID:qRowId,
				//hospDR:$HUI.combogrid('#_HospList').getValue()
				//2758853������ƻ����á�ҵ���������
				hospDR:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())
			});
		},
		onLoadSuccess:function(){
			//2758853������ƻ����á�ҵ���������
			if(PageLogicObj.iframeflag=="1"){
				$("#InterventionCopy").hide();
				$('#tabQLInterventionList').datagrid("hideColumn", "queCode");
				$('#tabQLInterventionList').datagrid("hideColumn", "queName");
				$('#tabQLInterventionList').datagrid("hideColumn", "careTypeT");
				$('#tabQLInterventionList').datagrid("hideColumn", "applyAreaStr");				
			}
		}
	})
}
//2758853������ƻ����á�ҵ���������
function ReloadQLInterventionListDataGrid(rowID){
	$("#QLInterventionEditWin").window('close');
	var status=$("#status").combobox('getValues');
	if (status.length ==1){
		status=status.join("");
	}else{
		status="-1";
	}
    try{
		$('#tabQLInterventionList').datagrid('reload',{
			searchName:$("#searchName").val(),
			status:status,
			searchQueRowID:rowID,
			hospDR:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue()),
			rows:999
		})
    }
    catch(err){	    
	    //alert(err.message)
	}
	PageLogicObj.selectQueRowID=rowID
	
	
}
function InitQLInterventionEditWin(){
	// ��������
	InitQuestion();
	// �������
	InitRelateFactor();
	// �����ʩ
	InitNursingMeasures();
	InittabQLInterventionEdit();
}
function InitQuestion(){
	$('#Question').combobox({
		// ��ȡ���õ����� 2021.7.6
		url:$URL+"?ClassName=Nur.NIS.Service.NursingPlan.QuestionSetting&QueryName=QueryQuestion&rows=99999&ResultSetType=array&statusIn=1",
		valueField:'rowID',
		textField:'shortName',
		mode: "remote",
		onSelect:function(rec){
			if (rec) {
				var applyArea=eval("("+rec.applyArea+")");
				if (applyArea.length >0) {
					var applyAreaDesc="";
					for (var i=0;i<rec.applyArea.length;i++){
						var index=$.hisui.indexOfArray(PageLogicObj.m_WardJson,"wardid",applyArea[i]);
						if (index >=0) {
							if (applyAreaDesc) applyAreaDesc=applyArea+","+PageLogicObj.m_WardJson[index].warddesc;
							else  applyAreaDesc=PageLogicObj.m_WardJson[index].warddesc;
						}
					}
				}else{
					var applyAreaDesc="ȫԺ";
				}
				$("#QuestionApplyArea").val(applyAreaDesc);
				$("#QuestionType").val(rec.careTypeT);
				$("#QuestionCode").val(rec.queCode);
				$('#tabQLInterventionEdit').datagrid("load",{queID:rec.rowID});
				$('#RelateFactor').combobox("reload",rewriteUrl($('#RelateFactor').combobox("options").url, {queID:rec.rowID}));
				$("#RelateFactor").next('span').find('input').focus();
			}
		},
		onBeforeLoad:function(param){
             //param = $.extend(param,{keyword:param["q"],hospitalID:$HUI.combogrid('#_HospList').getValue()});
        	 //2758853������ƻ����á�ҵ���������
        	 param = $.extend(param,{keyword:param["q"],hospitalID:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())});
        },
        onChange:function(newValue, oldValue){
	        if (!newValue) {
		        $("#QuestionType,#QuestionCode").val("");

		    }
	    }
	});
}
function InitRelateFactor(){
	$('#RelateFactor').combobox({
		url:$URL+"?ClassName=Nur.NIS.Service.NursingPlan.QuestionSetting&QueryName=GetDataList&queID=undefined&rows=99999&ResultSetType=array",
		valueField:'RowId',
		textField:'text',
		mode: "remote",
		method:"Get",
		loadFilter:function(data){
			var newData=new Array();
			for (var i=0;i<data.length;i++){
				var ReportTemplate=data[i].ReportTemplate;
				var AssessName=data[i].AssessName;
				var ReportItem=data[i].ReportItem;
				newData.push({
					"ReportItem":ReportItem,
					"ReportTemplate":ReportTemplate,
					"AssessName":AssessName,
					"RowId":data[i].RowId,
					"text":"<span style='font-weight: bold;color:rgb(51,51,51);'>ģ����룺</span>"+ReportTemplate+"<span style='font-weight: bold;color:rgb(51,51,51);'> ����ϵͳ��</span>"+AssessName+"<span style='font-weight: bold;color:rgb(51,51,51);'> ������أ�</span>"+ReportItem
				});
			}
			return newData;
		},
		onBeforeLoad:function(param){
			var desc=param["q"];
			if (!desc) desc="";
            //$.extend(param,{desc:desc,hospID:$HUI.combogrid('#_HospList').getValue()});
            //2758853������ƻ����á�ҵ���������
            $.extend(param,{desc:desc,hospID:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())});
        },
		onSelect:function(rec){
			if (rec) {
				$(this).combobox('setText',rec.ReportItem);
				var rows=$('#tabQLInterventionEdit').datagrid('getRows');
				if (rows.length >0) {
					var dataArray=new Array();
					for (var i=0;i<rows.length;i++){
						var Editors=$('#tabQLInterventionEdit').datagrid("getEditors",i);
						if (Editors.length >0) {
							var recordID=rows[i].recordID;
							if (recordID) {
								$('#tabQLInterventionEdit').datagrid("endEdit", i);
							}else{
								$('#tabQLInterventionEdit').datagrid('deleteRow', i);
							}
						}
					}
				}
			}
		},
		onChange:function(newValue, oldValue){
			if (!newValue) {
				var rows=$('#tabQLInterventionEdit').datagrid('getRows');
				if (rows.length >0) {
					var dataArray=new Array();
					for (var i=0;i<rows.length;i++){
						var Editors=$('#tabQLInterventionEdit').datagrid("getEditors",i);
						if (Editors.length >0) {
							var recordID=rows[i].recordID;
							if (recordID) {
								$('#tabQLInterventionEdit').datagrid("endEdit", i);
							}else{
								$('#tabQLInterventionEdit').datagrid('deleteRow', i);
							}
						}
					}
				}
			}
		}
	});
}
function InitNursingMeasures(){
	//intType:%String:��ʩ����,intCode:%String:��ʩ����,intShortName:%String:��ʩ������,intLongName:%String:��ʩ������,applayArea:%String:������Ⱥ,intStatus:%String:״̬,
	//intRowID:%String:hidden,intEnableDate:%String:hidden,intStopDate:%String:hidden,defFreq:%String:hidden
	$('#NursingMeasures').combobox({
		url:$URL+"?ClassName=Nur.NIS.Service.NursingPlan.InterventionSetting&QueryName=GetInterventionList&rows=99999&ResultSetType=array",
		valueField:'intRowID',
		textField:'intShortName',
		mode: "remote",
		method:"Get",
		onBeforeLoad:function(param){
             //param = $.extend(param,{searchName:param["q"],status:"",hospDR:$HUI.combogrid('#_HospList').getValue()});
        	 //2758853������ƻ����á�ҵ���������
        	 var desc=param["q"];
        	 if (typeof(param["q"])=="undefined") desc='' 
        	 param = $.extend(param,{searchName:desc,status:"",hospDR:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())});
        }
	});
}
function InittabQLInterventionEdit(){
	var Columns=[[    
		{ field: 'intCode', title: '��ʩ����',width:90},
		{ field: 'intType', title: '��ʩ����',width:120,
			formatter: function(value,row,index){
				return value.split("^")[1]+"("+value.split("^")[2]+")";
			}
		},
		{ field: 'intShortName', title: '��ʩ������',width:150,wordBreak:"break-all"},
		{ field: 'intLongName', title: '��ʩ������',width:300,wordBreak:"break-all"},
		{ field: 'intEnableDate', title: '��������',width:110,
			editor:{
				type:'dateboxq'
			}
		},
		{ field: 'intStopDate', title: 'ͣ������',width:110,
			editor:{
				type:'dateboxq'
			}
		},		
		{ field: 'Action', title: '����',
			formatter:function(value,row,index){
				var d = "<a href='#' onclick='DeleteRow(this)'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/></a>";
				return d;
			}
		}
    ]];
	$('#tabQLInterventionEdit').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false, 
		autoRowHeight : false,
		loadMsg : '������..',  
		pagination : false, 
		rownumbers : true, 
		idField:"intRowID",
		columns :Columns, 
		nowrap:false,  /*�˴�Ϊfalse*/
		url : $URL+"?ClassName=Nur.NIS.Service.NursingPlan.InterventionSetting&MethodName=GetInterventionListByQueID&rows=99999",
		onBeforeLoad:function(param){
			$('#tabQLInterventionEdit').datagrid("unselectAll");
			var queID=param["queID"];
			if (!queID) queID="";
			if ((PageLogicObj.iframeflag=="1")&&(queID=="")){ 
				var queID=window.parent.window.iframeQuestion.PageLogicObj.m_SelRowId;
			}
			param = $.extend(param,{
				queID:queID,
				//hospID:$HUI.combogrid('#_HospList').getValue(),
				//2758853������ƻ����á�ҵ���������
				hospID:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue()),
				reasonID:""
			});
		},
		onLoadSuccess:function(data){

			if ((data.total >0)&&(PageLogicObj.m_selQLLIntRowID)){
				var index=$('#tabQLInterventionEdit').datagrid("getRowIndex",PageLogicObj.m_selQLLIntRowID);
				if (index >=0) {
					$('#tabQLInterventionEdit').datagrid("beginEdit", index);
				}
			}
		}
	})
}
function DeleteRow(target){
	$.messager.confirm('ȷ�϶Ի���', "ȷ��Ҫɾ�����������ʩ�𣿴˻����ʩɾ���󣬻������⽫�����Զ������û����ʩ", function(r){
		if (r) {
			var tr = $(target).closest('tr.datagrid-row');
			var index=parseInt(tr.attr('datagrid-row-index'));
			var rows=$('#tabQLInterventionEdit').datagrid('getRows');
			var recordID=rows[index].recordID;
			if (recordID) {
				var rtn=$.m({
					ClassName:"Nur.NIS.Service.NursingPlan.InterventionSetting",
					MethodName:"DeleteIntervention",
					locID:session['LOGON.CTLOCID'],
					userID:session['LOGON.USERID'],
					recordID:recordID
				},false)
				if (rtn !=0) {
					$.messager.popover({msg:'ɾ�������ʩʧ�ܣ�',type:'error'});
					return false;
				}
			}
			$('#tabQLInterventionEdit').datagrid('deleteRow', index);
		}
	});
}
function AddQLMeasuresClick(){
	var QuestionData=$('#Question').combobox("getData");
	var Question=$("#Question").combobox('getValue');
	var Qindex=$.hisui.indexOfArray(QuestionData,"rowID",Question);
	if (Qindex <0) {
		$.messager.popover({msg:'��ѡ�������⣡',type:'error'});
		$('#Question').next('span').find('input').focus();
		return false;
	}
	var NursingMeasuresData=$('#NursingMeasures').combobox("getData");
	var NursingMeasures=$("#NursingMeasures").combobox('getValue');
	var QMindex=$.hisui.indexOfArray(NursingMeasuresData,"intRowID",NursingMeasures);
	if (QMindex <0) {
		$.messager.popover({msg:'��ѡ�����ʩ��',type:'error'});
		$('#NursingMeasures').next('span').find('input').focus();
		return false;
	}else {
		if ($('#tabQLInterventionEdit').datagrid('getRowIndex',NursingMeasures) >=0) {
			$.messager.popover({msg:'�����ʩ�Ѵ���',type:'error'});
			$('#NursingMeasures').next('span').find('input').focus();
			return false;
		}
	}
	var reasonID="",reasonStr="";
	var RelateFactorData=$('#RelateFactor').combobox("getData");
	var RelateFactor=$("#RelateFactor").combobox('getValue');
	var QRLindex=$.hisui.indexOfArray(RelateFactorData,"RowId",RelateFactor);
	if ((RelateFactor)&&(QRLindex <0)) {
		$.messager.popover({msg:'��ѡ���������',type:'error'});
		$('#RelateFactor').next('span').find('input').focus();
		return false;
	}
	if (RelateFactor) {
		reasonID=RelateFactor;
		reasonStr=RelateFactorData[QRLindex].ReportItem;
	}
	$('#tabQLInterventionEdit').datagrid('appendRow',{
		applyAreaStr:QuestionData[Qindex].applyArea,
		careTypeT: QuestionData[Qindex].careTypeT,
		careTypeV: QuestionData[Qindex].careTypeV,
		intCode:NursingMeasuresData[QMindex].intCode,
		intEnableDate:ServerObj.CurrentDate,
		intLongName:NursingMeasuresData[QMindex].intLongName,
		intRowID:NursingMeasures,
		intShortName:NursingMeasuresData[QMindex].intShortName,
		intStatus: NursingMeasuresData[QMindex].intStatus,
		intStopDate:"",
		intType:NursingMeasuresData[QMindex].intType,
		queCode: QuestionData[Qindex].queCode,
		queName: QuestionData[Qindex].shortName,
		queRowID: QuestionData[Qindex].rowID,
		queTypeDesc: QuestionData[Qindex].queTypeDesc,
		queTypeDr: QuestionData[Qindex].queTypeDr,
		reasonID:reasonID, //�������ID
		reasonStr:reasonStr, //�������
		recordID:"",
		rowID: ""
	});
	$('#tabQLInterventionEdit').datagrid("beginEdit", $('#tabQLInterventionEdit').datagrid('getRows').length-1);
	//����3214097
	$("#NursingMeasures").combobox('loadData', {});
	$("#NursingMeasures").combobox("setValue",'').combobox("setText","");
	$("#NursingMeasures").combobox('reload');
	$('#NursingMeasures').next('span').find('input').focus();
}
function InitEditWindow(){
    $("#QLInterventionEditWin" ).window({
	   modal: true,
	   collapsible:false,
	   minimizable:false,
	   maximizable:false,
	   closed:true,
	   onClose:function(){
		   ClearQLInterventionEditWinData();
	   }
	});
}
function SaveQLInterventionClick(){
	var rows=$('#tabQLInterventionEdit').datagrid('getRows');
	if (rows.length ==0) {
		$.messager.popover({msg:'��ѡ�������⼰������أ����������ʩ��',type:'error'});
		return false;
	}
	var dataArray=new Array();
	for (var i=0;i<rows.length;i++){
		var Editors=$('#tabQLInterventionEdit').datagrid("getEditors",i);
		if (Editors.length >0) {
			var recordID=rows[i].recordID;
			var reasonID=rows[i].reasonID;
			if (!reasonID) reasonID="";
			var reasonStr=rows[i].reasonStr;
			if (!reasonStr) reasonStr="";
			var intType=rows[i].intType;
			var intTypeDesc=intType.split("^")[1]+"("+intType.split("^")[2]+")"
			if (recordID){
				dataArray.push({
					"applyAreaStr":[""],
					"careTypeT":rows[i].careTypeT,
					"careTypeV":rows[i].careTypeV,
					"intCode":rows[i].intCode,
					"intEnableDate":$(Editors[0].target).dateboxq('getValue'),
					"intLongName":rows[i].intLongName,
					"intRowID":rows[i].intRowID,
					"intShortName":rows[i].intShortName,
					"intStatus":rows[i].intStatus,
					"intStopDate":$(Editors[1].target).dateboxq('getValue'),
					"intType":intType.split("^")[0],
					"queCode":rows[i].queCode,
					"queName":rows[i].queName,
					"queRowID":rows[i].queRowID,
					"queTypeDesc":rows[i].queTypeDesc,
					"queTypeDr":rows[i].queTypeDr,
					"reasonID":reasonID,
					"reasonStr":reasonStr,
					"recordID":rows[i].recordID,
					"rowID":rows[i].rowID,
					"intTypeDesc":intTypeDesc,
					"editable":true,
					"intTypeID":intType.split("^")[0]
				})
			}else{
				dataArray.push({
					"intCode":rows[i].intCode,
					"intEnableDate":$(Editors[0].target).dateboxq('getValue'),
					"intLongName":rows[i].intLongName,
					"intRowID":rows[i].intRowID,
					"intShortName":rows[i].intShortName,
					"intStopDate":$(Editors[1].target).dateboxq('getValue'),
					"intType":intType.split("^")[0],
					"queCode":rows[i].queCode,
					"queName":rows[i].queName,
					"queRowID":rows[i].queRowID,
					"intTypeDesc":intTypeDesc,
					"editable":true,
					"intTypeID":intType.split("^")[0],
				})
			}
		}
	}
	$.m({
		ClassName:"Nur.NIS.Service.NursingPlan.InterventionSetting",
		MethodName:"BatchSaveIntervention",
		locID:session['LOGON.CTLOCID'],
		userID:session['LOGON.USERID'],
		dataArray:JSON.stringify(dataArray),
		//hospitalDR:$HUI.combogrid('#_HospList').getValue(),
		//2758853������ƻ����á�ҵ���������
		hospitalDR:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue()),
		reasonStr:reasonID
	},function (rtn){
		if(rtn == 0) {
			$.messager.popover({msg:'����ɹ���',type:'success'});
			$("#QLInterventionEditWin").window('close');
			$("#tabQLInterventionList").datagrid("reload");
		} else {
			$.messager.alert('��ʾ','����ʧ�ܣ��������: '+ rtn , "info");
			return false;
		}
	})
}
function ClearQLInterventionEditWinData(){
	$('#Question,#RelateFactor,#NursingMeasures').combobox("setValue","");
	$("#QuestionType,#QuestionCode").val("");
	$('#tabQLInterventionEdit').datagrid("load",{queID:""});
	$('#RelateFactor').combobox("reload",rewriteUrl($('#RelateFactor').combobox("options").url, {queID:"undefined"}));
	PageLogicObj.m_selQLLIntRowID="";
}
function searchNameOnKeyDown(e){
	var key=websys_getKey(e);
	if (key==13){
		$("#tabQLInterventionList").datagrid("reload");
	}
}
function SetQLInterventionRowData(row){
	$("#Question").combobox("setValue",row.queRowID);
	$("#QuestionType").val(row.careTypeT);
	$("#QuestionCode").val(row.queCode);
	var applyAreaStr=eval("("+row.applyAreaStr+")").join("��");
	if (!applyAreaStr) applyAreaStr="ȫԺ";
	$("#QuestionApplyArea").val(applyAreaStr);
	$('#RelateFactor').combobox("reload",rewriteUrl($('#RelateFactor').combobox("options").url, {queID:row.queRowID}));
	setTimeout(function(){
		$("#RelateFactor").combobox("setValue",row.reasonID).combobox("setText",row.reasonStr);
	},500)
	$("#NursingMeasures").combobox("setValue","");
	$('#tabQLInterventionEdit').datagrid("load",{queID:row.queRowID});
	$("#NursingMeasures").next('span').find('input').focus();
	PageLogicObj.m_selQLLIntRowID=row.intRowID;
}

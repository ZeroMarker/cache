///taskoverview.config.js

//ҳ���ʼ����������
$(window).load(function() {
	//�������ֲ�
	$("#loading").hide();
	//��ʼ����Ժ��
	hospList()
	//���ر��б�
	loadDataGridList()

})


function hospList(){
	//����ҽԺ�����б�
	var hospComp = GenHospComp("Nur_IP_Question");
	hospComp.jdata.options.onSelect = function(e,t){
		loadDataGridList();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		loadDataGridList();
	}
}

////start loadDataGrid
function loadDataGridList(){
	$('#tabQuestionList').datagrid({  
			fit : true,
			width : 'auto',
			border : false,
			striped : true,
			singleSelect : true,
			fitColumns : false,
			autoRowHeight : false,
			loadMsg : '������..',  
			pagination : true, 
			rownumbers : true,
			idField:"rowID",
			pageSize: 15,
			pageList : [15,50,100,200],
			columns :dataGridColumns(),
			toolbar :dataGridToolBar(),
			autoRowHeight:true,
			nowrap:false,  /*�˴�Ϊfalse*/
			url : $URL+"?ClassName=Nur.NIS.Service.TaskOverview.Setting&QueryName=GetTaskOverNormList",
			onBeforeLoad:function(param){
				$('#tabQuestionList').datagrid("unselectAll");
				var locId = session['LOGON.CTLOCID']
				param = $.extend(param,{keyword:$("#SearchDesc").val(),loc:locId,hospDR:$HUI.combogrid('#_HospList').getValue(),groupFlag:""})
				
			}
			
		})
	
}

function dataGridColumns(){
	var taskType={
		NORMAL:"����",
		SIGNS:"����",
		ORDER:"ҽ��",
		EVENT:"�¼�",
		SIGNORDER:"����+ҽ��",
		MUTIPLY:"�¼�+ҽ��",
		SPECIAL:"����",
		ASSESS:"����",
		ORDERASSESS:"ҽ��+����"
	}
	var Columns=[[
  		{ field: 'id',title:'id',width:50,wordBreak:"break-all"},
		{ field: 'taskCode',title:'Code',width:200,wordBreak:"break-all"},
		{ field: 'taskDesc',title:'���滤����������',width:200,wordBreak:"break-all"},
		{ field: 'taskAttr',title:'��������',width:90,wordBreak:"break-all",
			formatter: function(value,row,index){
				var names=["��������","��������","���ƴ���"]
				return names[value-1]
			}},
		{ field: 'type',title:'����',width:90,wordBreak:"break-all",
			formatter: function(value,row,index){
				return taskType[value]
			}},
		{ field: 'exePeriod',title:'ִ����Чʱ���趨',width:150,
			formatter: function(value,row,index){
				var names=["��ִ��","�����","����","ʱ���"]
				return names[value]
			}
		},
		{ field: 'applyPatient',title:'������Ⱥ',width:200,wordBreak:"break-all",
			formatter: function(value,row,index){
				var names=["","����","Ӥ��","��ͯ","������"]
				return names[value]
			}},
		{ field: 'locsName',title:'��Ч����',width:200,wordBreak:"break-all"},
		{ field: 'invalidLocs',title:'��Ч����',width:200,wordBreak:"break-all"}
	
    ]];	
	return 	Columns
}
function dataGridToolBar(){
	var ToolBar = [{
        text: '����',
        iconCls: 'icon-add',
        handler: function() {
			openWin("")				
       
        }
    },{
        text: '�޸�',
        iconCls: 'icon-write-order',
        handler: function() {
	        var row = $("#tabQuestionList").datagrid("getSelected");
			openWin(row.id)
			
        }
    },{
        text: 'ɾ��',
        iconCls: 'icon-cancel',
        handler: function() {
            var row = $("#tabQuestionList").datagrid("getSelected");
			if (!row) {
				$.messager.alert("��ʾ","��ѡ����Ҫɾ���ļ�¼��");
				return false;
			}
			
			$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
			    if (r){
				    var UserId = session['LOGON.USERID']
					runClassMethod("CF.NUR.NIS.TaskOverview","DeleteTaskOverNorm",{ID:row.id,UserId:UserId},function(data){
						$.messager.alert("��ʾ","�ɹ�ɾ����¼��");
						loadDataGridList();
					},'json',false);
			    }    
			}); 
        }
    }];
    return ToolBar
}

function openWin(id){
	
	
	var hospid = $HUI.combogrid('#_HospList').getValue()
	
	
	var url="nur.hisui.taskoverview.config.csp?taskId="+id+"&hospId="+hospid
	console.log(url)
	$('#dialogRefer').dialog({
        title: '���滤������',
        width: 600,
        height: 600,
        	
        cache: false,
        content: "<iframe id='iframeRefer' scrolling='auto' frameborder='0' src='" + url + "' style='width:100%; height:100%; display:block;'></iframe>",
        modal: true
    });
    $("#dialogRefer").dialog("open");	
}

function closeHandler(){
	 $('#dialogRefer').dialog('close');	
}
function sureReferHandler(){
	var $iframe = $('#iframeRefer')[0].contentWindow
	var rsflag = $iframe.saveFunLib("1")
	if(rsflag){
		$.messager.popover({msg:'����ɹ���',type:'success'});
		loadDataGridList()
		$('#dialogRefer').dialog('close');	
	}
}
function copySureReferHandler(){
	var $iframe = $('#iframeRefer')[0].contentWindow
	var rsflag = $iframe.saveFunLib("2")
	if(rsflag){
		$.messager.popover({msg:'����ɹ���',type:'success'});
		loadDataGridList()
		$('#dialogRefer').dialog('close');
	}else{
		
	}	
}

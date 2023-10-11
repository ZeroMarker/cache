/**
 * Description����������
 * FileName: dhcpe.ct.hm.evaluterecord.js
 * @Author   wangguoying
 * @DateTime 2021-08-10
 */
 
 
var RecordDataGrid = $HUI.datagrid("#RecordList",{
		url:$URL,
		bodyCls:'panel-body-gray',
		border:false,
		singleSelect:true,
		queryParams:{
			ClassName:"web.DHCHM.OEvaluationRecord",
			QueryName:"OEvaluationRecordNew",
			Type:"E"
		},
		onSelect:function(rowIndex,rowData){
			var RecorID=rowData.ID
			TreeLoad(RecorID);
			closeAllTabs("TabPanel");
		},
		onDblClickRow:function(index,row){
															
		},	
		columns:[[
			{field:'ID',hidden:true,sortable:'true'},
			{field:'BIRegNo',width:'80',title:'�ǼǺ�'},
			{field:'THPNo',width:'100',title:'����'},
			/*{field:'TEQStatus',width:'80',title:'״̬',align:"center",
			formatter: function(value, row, index) {
				var content = "";
				switch (row.TEQStatus) {
					case "0":
						content ="δ����";
						break;
					case "1":
						content = "���ֱ���";
						break;
					case "2":
						content = "ȫ������";
						break;
					case "3":
						content = "���ύ";
				}
				return "<div style='color:#ffffff;'>" + content + "</div>";
			},
			styler: function(value, row, index) {
				var color = "#ffffff";
				switch (row.TEQStatus) {
					case "0":
						color = "red";
						break;
					case "1":
						color = "#40A2DE";
						break;
					case "2":
						color = "rgb(101, 222, 101)";
						break;
					case "3":
						color = "green";
						break;
				}
				return "background-color:" + color + ";";
			}
			},
			//{field:'SubmitUserName',width:'80',title:'�ύ��'},*/
			{field:'BIName',width:'60',title:'����'},
			{field:'SexDesc',width:'40',title:'�Ա�'},
			{field:'TAge',width:'40',title:'����'},
			{field:'TIDCardNo',width:'100',title:'���֤��'},
			{field:'TBICode',hidden:true,width:'40',title:'����'},
			{field:'AdmDate',width:'80',title:'��������'},
			{field:'EducationDesc',hidden:true,width:'70',title:'ѧ��'},
			{field:'MaritalDesc',hidden:true,width:'70',title:'���'},
			{field:'OccupationDesc',hidden:true,width:'70',title:'ְҵ'},
			{field:'QPostCode',hidden:true,width:'80',title:'������������'},
			{field:'QRemark',hidden:true,width:'120',title:'��ע'},
			{field:'TExamSurveyFlag',hidden:true,width:'20',title:'��¼��'}
		]],
		onLoadSuccess:function(data){
			if(data.rows.length==1){
				$("#RecordList").datagrid("selectRow",0);
			}
		},
		pagination:true,
		pageSize:10,
		fit:true
	});
/*	
$HUI.combogrid("#Doctor",{
		panelWidth:470,
		url:$URL+"?ClassName=web.DHCPE.Report.DoctorWorkStatistic&QueryName=SearchUSERSXT",
		mode:'remote',
		delay:200,
		idField:'DocDr',
		textField:'DocName',
		onBeforeLoad:function(param){
			param.Desc = param.q;
		},
		columns:[[
		    {field:'DocDr',title:'ID',width:40},
			{field:'DocName',title:'����',width:200},
			{field:'Initials',title:'����',width:200}					
		]],
		onLoadSuccess:function(){
			//$("#UserName").combogrid('setValue',""); 
		},
		fitColumns:true,
		pagination:true,
		pageSize:50,
		fit:true
});	*/	

function init()
{
	$("#RegNo").keydown(function(e){
 		 var Key=websys_getKey(e);
		if ((13==Key)) {
			find_onclick();
		}
	});

	TreeLoad("");
}


function closeAllTabs(id){  
         var arrTitle = new Array();  
         var id = "#"+id;//Tab���ڵĲ��ID  
         var tabs = $(id).tabs("tabs");//�������СTab  
         var tCount = tabs.length;  
         if(tCount>0){  
                     //�ռ�����Tab��title  
             for(var i=0;i<tCount;i++){  
                 arrTitle.push(tabs[i].panel('options').title)  
             }  
                     //�����ռ���titleһ��һ��ɾ��=====���Tab  
             for(var i=0;i<arrTitle.length;i++){  
                 $(id).tabs("close",arrTitle[i]);  
             }  
         }  
 };

/**
 * �������ṹ
 * @param {int} RecorID [������¼ID]
 * @Author   wangguoying
 * @DateTime 2019-04-30
 */
function TreeLoad(RecordID)
{
	$.cm({
			wantreturnval: 1,
			ClassName: 'web.DHCHM.GetTreeInfo',
			MethodName: 'GetQuestionTreeJson',
			RecordID:RecordID,
			Type: 'E'
		},function(ret){
			$('#QuestionTree').tree({
				onSelect: function(node){
					if(!node.id.startWith("Question")){
						showTabPanel(node);
					}					
				},
				data: ret
			});
			//�Զ�ѡ������ڵ�
			if(ret && ret.length==1 && ret[0].children ){
				var quesNode = ret[0].children[0];
				if(quesNode.children && quesNode.children.length==1 ){
					var id = quesNode.children[0].id;
					var node = $('#QuestionTree').tree('find', id);
					$('#QuestionTree').tree('select', node.target);
				}
			}
		});
}

/**
 * չʾTab
 * @param    {[object]}    node [���ڵ�]
 * @Author   wangguoying
 * @DateTime 2019-04-30
 */
function showTabPanel(node)
{
	if($('#TabPanel').tabs("getTab",node.text))
	{
		$('#TabPanel').tabs("select",node.text);
	}else{
		var Type=node.id.substr(0,1);
		var EQID=node.id.substr(1);
		var content="";
		switch(Type){
			case "Q":
				content='<iframe src="dhchm.questiondetailset.keyword.csp?EQID='+EQID+'" width="100%" height="100%" frameborder="0"></iframe>';
				break;
			case "E":
				content='<iframe src="dhchm.oevaluation.csp?EQID='+EQID+'" width="100%" height="100%" frameborder="0"></iframe>';
				break;
			case "T":
				content='<iframe src="dhchm.medicaltips.csp?EQID='+EQID+'" width="100%" height="100%" frameborder="0"></iframe>';
				break;
			case "I":
				content='<iframe src="dhchm.inquiry.result.csp?EQID='+EQID+'" width="100%" height="100%" frameborder="0"></iframe>';
				break;
		}
		$('#TabPanel').tabs('add',{
			selected:true,
			closable:true,
			id:node.id,
    		title:node.text,
    		content:content
		});
		document.getElementById(node.id).style.overflow='hidden';
	}
	
}


/**
 * ѯ��ť����¼�
 * @Author   wangguoying
 * @DateTime 2019-04-29
 */
function find_onclick(){
	var StartDate=$('#StartDate').datebox('getValue');
	var EndDate=$('#EndDate').datebox('getValue');
	var Code=$("#BICode").val();
	var Name=$("#Name").val();
	var RegNo=$("#RegNo").val();
	if(RegNo!=""){
		RegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",RegNo);
		$("#RegNo").val(RegNo);
	}
	var Doctor = "";	//$("#Doctor").combogrid("getValue");
	RecordDataGrid.load({ClassName:"web.DHCHM.OEvaluationRecord",QueryName:"OEvaluationRecordNew",AStartDate:StartDate,AEndDate:EndDate,RegNo:RegNo,Name:Name,Code:Code,Type:"E",Doctor:Doctor});
	closeAllTabs("TabPanel");
}





//ʵ��js ��startwidth
 String.prototype.startWith = function(s) { 
    if (s == null || s == "" || this.length == 0 || s.length > this.length) 
        return false; 
    if (this.substr(0, s.length) == s) 
         return true;
    else 
        return false; 
    return true; 
}

String.prototype.endWith = function(s) {
     if (s == null || s == "" || this.length == 0|| s.length > this.length)
          return false;
     if (this.substring(this.length - s.length) == s)
          return true;
     else
          return false;
    return true;
}

$(init);
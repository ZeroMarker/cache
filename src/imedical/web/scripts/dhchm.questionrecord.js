/**
 * ��������  dhchm.questionrecord.js
 * @Author   wangguoying
 * @DateTime 2019-04-29
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
			{field:'BIRegNo',width:'100',title:'�ǼǺ�'},
			{field:'BIName',width:'60',title:'����'},
			{field:'SexDesc',width:'40',title:'�Ա�'},
			{field:'TBICode',width:'40',title:'����'},
			{field:'QAddDate',width:'100',title:'����'},
			{field:'EducationDesc',hidden:true,width:'70',title:'ѧ��'},
			{field:'MaritalDesc',hidden:true,width:'70',title:'���'},
			{field:'OccupationDesc',hidden:true,width:'70',title:'ְҵ'},
			{field:'QPostCode',hidden:true,width:'80',title:'������������'},
			{field:'QRemark',hidden:true,width:'120',title:'��ע'}
		]],
		pagination:true,
		pageSize:10,
		fit:true
	});
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
		},function(data){
			$('#QuestionTree').tree({
				onClick: function(node){
					if(!node.id.startWith("Question")){
						showTabPanel(node);
					}					
				},
				data: data
			});
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
	RecordDataGrid.load({ClassName:"web.DHCHM.OEvaluationRecord",QueryName:"OEvaluationRecordNew",StartDate:StartDate,EndDate:EndDate,RegNo:RegNo,Name:Name,Code:Code,Type:"E"});
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
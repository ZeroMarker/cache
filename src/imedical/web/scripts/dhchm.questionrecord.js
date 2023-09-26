/**
 * 健康评估  dhchm.questionrecord.js
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
			{field:'BIRegNo',width:'100',title:'登记号'},
			{field:'BIName',width:'60',title:'姓名'},
			{field:'SexDesc',width:'40',title:'性别'},
			{field:'TBICode',width:'40',title:'编码'},
			{field:'QAddDate',width:'100',title:'日期'},
			{field:'EducationDesc',hidden:true,width:'70',title:'学历'},
			{field:'MaritalDesc',hidden:true,width:'70',title:'婚否'},
			{field:'OccupationDesc',hidden:true,width:'70',title:'职业'},
			{field:'QPostCode',hidden:true,width:'80',title:'行政区划编码'},
			{field:'QRemark',hidden:true,width:'120',title:'备注'}
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
         var id = "#"+id;//Tab所在的层的ID  
         var tabs = $(id).tabs("tabs");//获得所有小Tab  
         var tCount = tabs.length;  
         if(tCount>0){  
                     //收集所有Tab的title  
             for(var i=0;i<tCount;i++){  
                 arrTitle.push(tabs[i].panel('options').title)  
             }  
                     //根据收集的title一个一个删除=====清空Tab  
             for(var i=0;i<arrTitle.length;i++){  
                 $(id).tabs("close",arrTitle[i]);  
             }  
         }  
 };

/**
 * 加载树结构
 * @param {int} RecorID [评估记录ID]
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
 * 展示Tab
 * @param    {[object]}    node [树节点]
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
 * 询按钮点击事件
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





//实现js 的startwidth
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
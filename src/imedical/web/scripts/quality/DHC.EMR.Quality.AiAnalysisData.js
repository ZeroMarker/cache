$(function(){
	InitDataList();

});
var editIndex=undefined;
var modifyBeforeRow = {};
var modifyAfterRow = {};
function endEditing(){
		if (editIndex == undefined){return true}
		if ($('#ListTable').datagrid('validateRow', editIndex)){
			//列表中下拉框实现，修改后把回写feetypename，因为formatter显示的是feetypename字段
			var ed = $('#ListTable').datagrid('getEditor', {index:editIndex,field:'Tag'});
			var TagDesc = $(ed.target).combobox('getText');
			$('#ListTable').datagrid('getRows')[editIndex]['TagDesc'] = TagDesc;
			$('#ListTable').datagrid('endEdit', editIndex);
			/*modifyAfterRow = $('#ListTable').datagrid('getRows')[editIndex];
			var aStr = JSON.stringify(modifyAfterRow);
			var bStr = JSON.stringify(modifyBeforeRow);
			if(aStr!=bStr){
				console.log('修改前：');
				console.dir(modifyBeforeRow);
				console.log('修改后：');
				console.dir(modifyAfterRow);
			}*/
			SaveTag(editIndex)
			editIndex = undefined;
			
			return true;
		} else {
			return false;
		}
	}
function onClickRow(index){
	if (editIndex!=index) {
		if (endEditing()){
			$('#ListTable').datagrid('selectRow', index)
					.datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $.extend({},$('#ListTable').datagrid('getRows')[editIndex]);
		} else {
			$('#ListTable').datagrid('selectRow', editIndex);
		}
	}
}
function InitDataList()
{
	$('#ListTable').datagrid({ 
			pagination: true,
            pageSize: 10,
            pageList: [10, 20, 50],
			method: 'post',
            loadMsg: '加载中......',
			autoRowHeight: true,
			fitColumns:true,
			url:'../EPRservice.Quality.Ajax.AiAnalysis.cls',
			queryParams: {
				StartDate:startDate,
				EndDate: endDate,
				Action:Type
            },
			fit:true,
			scrollbarSize:0,
			onClickRow: onClickRow,
			columns:[[
				//{field: 'ckb', checkbox: true },
				{field:'Name',title:'姓名',width:100,align:'left'},
				{field:'RegNo',title:'登记号',width:100,align:'left'},
				{field:'EpisodeID',title:'就诊号',width:100,align:'left'},
				{field:'LocDesc',title:'科室',width:100,align:'left'},
				{field:'DoctorDesc',title:'主治医生',width:100,align:'left'},
				{field:'EntryTitle',title:'质控条目',width:300,align:'left',showTip:true},
				{field:'ErrorText',title:'反馈信息',width:100,align:'left',hidden:Type!="AiErrDetail",showTip:true},
				{field:'ResumeText',title:'备注',width:100,align:'left',hidden:Type=="AiErrDetail",showTip:true},
				{field:'SignUserDesc',title:'操作人',width:100,align:'left'},
				{field:'ExamineDate',title:'质控时间',width:100,align:'left'},
				{field:'Tag',title:'标记',width:100,align:'left',hidden:Type!="AiErrDetail",exportHidden:true,
					formatter:function(v,r){
							return emrTrans(r.TagDesc)
						},
						editor:{
							type:'combobox',
							options:{
								valueField:'Tag',
								textField:emrTrans('TagDesc'),
								method:'get',
								url:'../EPRservice.Quality.Ajax.AiAnalysis.cls?Action=GetTag'
								
							}
						}
				},
				{field:'TagDesc',title:'标记',width:100,align:'left',hidden:true,exportHidden:Type!="AiErrDetail"},
				{field:'Remarks',title:'标记备注',width:100,align:'left',editor:'text',hidden:Type!="AiErrDetail"},
				{field:'btnsave',title:'保存',width:60,align:'left',hidden:Type!="AiErrDetail",editor:{},
					formatter:function(value,row,index){ 
					return '<span class="icon-save" style="cursor:pointer">&nbsp;&nbsp;&nbsp;&nbsp;</span>'
					}	
					
				},
				{field:'View',title:'病历',width:100,align:'left',
				formatter:function(value,row,index){ 
					return '<span class="icon-eye" style="cursor:pointer">&nbsp;&nbsp;&nbsp;&nbsp;</span>'
					}}	
				
			]],
			toolbar: [{
				iconCls:'icon-download',
				text:'下载表格',
				handler: function (){exportExcel()}
			}],
			onClickCell: function(rowIndex, field, value) {
				var rows = $('#ListTable').datagrid('getRows');
				var row = rows[rowIndex];
				var episodeID = row.EpisodeID;
				if(field =='View'){
				var url = "emr.browse.csp?&EpisodeID="+episodeID+"&Action=quality";
				//var url = "emr.browse.csp?&EpisodeID="+episodeID;
				if('undefined' != typeof websys_getMWToken)
				{
					url += "&MWToken="+websys_getMWToken()
				}
				window.open (url,'newwindow','height=800,width=1280,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=yes,location=no, status=no') 	
				}
				if(field == 'btnsave'){
					endEditing();
				}
			},
			loadFilter:function(data)
			{
				endEditing();
				if(typeof data.length == 'number' && typeof data.splice == 'function'){
					data={total: data.length,rows: data}
				}
				var dg=$(this);
				var opts=dg.datagrid('options');
				var pager=dg.datagrid('getPager');
				pager.pagination({
					onSelectPage:function(pageNum, pageSize){
						opts.pageNumber=pageNum;
						opts.pageSize=pageSize;
						pager.pagination('refresh',{pageNumber:pageNum,pageSize:pageSize});
						dg.datagrid('loadData',data);
					}
				});
				if(!data.originalRows){
					data.originalRows = (data.rows);
				}
				var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
				var end = start + parseInt(opts.pageSize);
				data.rows = (data.originalRows.slice(start, end));
				return data;
			}
			}); 
			
			
}

function doSearch()
{	
	var DateStart=$("#inputCreateDateStart").datetimebox('getText');
	var DateEnd=$("#inputCreateDateEnd").datetimebox('getText')
	
	var queryParams = $('#CorectListTable').datagrid('options').queryParams;
    queryParams.StartDate = DateStart;
    queryParams.EndDate =DateEnd;
    $('#CorectListTable').datagrid('options').queryParams = queryParams;
    $('#CorectListTable').datagrid('reload');
    	
    var queryParams = $('#UseListTable').datagrid('options').queryParams;
    queryParams.StartDate =DateStart; 
    queryParams.EndDate =DateEnd;
    $('#UseListTable').datagrid('options').queryParams = queryParams;
    $('#UseListTable').datagrid('reload');	
    
    eprPatient.StartDate=DateStart;
	eprPatient.EndDate =DateEnd;	
    CorectListView("CorectListView")
    AcceptRateView("UseListView")   	
}

function SaveTag(editIndex)
{
	
	var row=$('#ListTable').datagrid('getRows')[editIndex]
	if (row['Tag']=="") {return;}
	var Input=row['EpisodeID']+"^"+row['EntryTitle']+"^"+row['Tag']+"^"+row['Remarks']
	jQuery.ajax({
				type: "get",
				dataType: "text",
				url: "../EPRservice.Quality.Ajax.AiAnalysis.cls",
				async: true,
				data: {
					"Action":"SaveTag",	
					"Input":Input,
					
				},
				success: function(d) {	
				if (d>0)
				{			
					$.messager.popover({
						msg: '保存成功！',
						type: 'success',
						timeout: 1000, 		//0不自动关闭。3000s
						showType: 'slide'  //show,fade,slide
					});	
				}else if(d=="-1")
				{
					$.messager.popover({
						msg: '保存失败！',
						type: 'error',
						timeout: 1000, 		//0不自动关闭。3000s
						showType: 'slide'  //show,fade,slide
					});
				}else if (d=="noEdit")
				{
					
				}else{alert(d)}
				}
	})	
}

function exportExcel(){
    var options = $('#ListTable').datagrid('getPager').data("pagination").options; 
    var curr = options.pageNumber; 
    var total = options.total;
    var pager = $('#ListTable').datagrid('getPager');
    var rows = []
    for (i=1;i<=((total/options.pageSize)+1);i++)
    {
	     pager.pagination('select',i);
         pager.pagination('refresh');
         var currows =  $('#ListTable').datagrid('getRows');
         console.log(currows)
         if (currows.length==0)
         {
	         continue;
	     }
         for (var j in currows)
         {
	         rows.push(currows[j]);
	     }
         //rows.concat(currows);
	}
	 pager.pagination('select',curr);
     pager.pagination('refresh');
	$('#ListTable').datagrid('toExcel',{
		filename:'明细.xls',
		rows:rows
		});
	}
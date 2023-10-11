$(function() {
    setDataGrid();
    InitErrorDialog();
});
var ErrorIndex=""
function setDataGrid() {
    $('#QualityData').datagrid({
        pageSize: 20,
        pageList: [10, 20, 30],
        loadMsg: '数据装载中......',
        autoRowHeight: true,
        url: '../EPRservice.Quality.Ajax.CompositeResult.cls?Action=GetQualityResult&EpisodeID='+EpisodeID+'&Dictionary='+Dictionary+'&action='+action,
        rownumbers: true,
        pagination: false,
        singleSelect: true,
        fitColumns: true,
        fit: true,
        nowrap:false,
        scrollbarSize:0,
        columns: [
            [{
                field: 'StructName',
                title: '质控缺陷',
                halign: 'left',
                width: 100,
				styler : function(value, row, index) {
						//return 'border-left:0;border-right:0;';
					}
	            }, 
             {
                field: 'Button',
                title: '1',
                halign: 'left',
                width: 150,
                hidden:true
            },
            {field:'Save',title:'',align:'left',width:40,
				formatter:function(value, row, index){
					if ((row.ItemInDetail==1)||(row.ItemInAiResult==1)||(row.Button==0)){
						str=row.StrDate
					}else{
					var str = '<a href="#" name="save" id="Save'+index+'" class="hisui-linkbutton" onclick="Save('+index+","+EpisodeID+')"  ></a>';
					}
					return str;
			},
			styler : function(value, row, index) {
					//return 'border-left:0;border-right:0;';
				}
			},
			{field:'Error',title:'',align:'left',width:55,
				formatter:function(value, row, index){
					if ((row.ItemInDetail==1)||(row.ItemInAiResult==1)||(row.Button==0)){
						str=row.EndDate	
					}else{
					var str = '<a href="#" name="error" id="Error'+index+'" class="hisui-linkbutton" onclick="Error('+index+')"  ></a>';
					}
					return str;
			},
			styler : function(value, row, index) {
					//return 'border-left:0;';
				}
			}
            ]
        ],
        view: groupview,
        groupField: 'Button',
        groupFormatter: function(value, rows) {
	        if (value=="0")
	        {
            	return  '<span style="color:rgb(1,123,236);font-size:16px;font-weight:bold;">'+$g('时效性质控')+'（' + rows.length+'）</span>';
	        }else{
		        return  '<span style="color:rgb(1,123,236);font-size:16px;font-weight:bold;">'+$g('内涵质控')+'（' + rows.length+'）</span>';
		    }
	        
        },
        onCheck: function(rowIndex, rowData) {

			if (rowData.instanceid!="")
			{
				
				if (typeof window.parent.parent.frames[0].frames[0].frames[0].frames[0].qualityLoadRecord == "function")
				{
				window.parent.parent.frames[0].frames[0].frames[0].frames[0].qualityLoadRecord(rowData.instanceid)
				}

        	}
        	
        },
        onUncheck: function(rowIndex, rowData) {
			
        },
        onCheckAll: function(rows) {

        },
        onUncheckAll: function(rows) {

        },
        onLoadSuccess:function(data){  
	        $("a[name='save']").linkbutton({text:'保存',plain:true,iconCls:'icon-ok'}); 
	        $("a[name='error']").linkbutton({text:'错误反馈',plain:true,iconCls:'icon-cancel'}); 
		},
		rowStyler: function (index, row) {
			if (row.ItemInDetail == 1) {
				return 'color:green;';
			}
			else if (row.ItemInAiResult == 1) {
				return 'color:red;';   
			}
		}
		
    });
    
}

function Save(index,EpisodeID){
	var rows = $("#QualityData").datagrid("getRows");
	var row = rows[index];
	var EntryID = row.EntryID;
	var StructName = row.StructName;
	var EmployeeID = row.EmployeeID;
	var LocID = row.LocID;
	var EntryScore = row.EntryScore;
    var Number = "1";
    var Remark = row.ResumeText;
	var EmrDocId = "";
	var InstanceId=""
	var ChangeData=EpisodeID + "^" + "1" + "^" + EntryID + "^" + LocID + "^" + EmployeeID + "^" + SignUserID + "^" + Number + "^" + TriggerDate + "^" + Remark + "^" +  action + "^" + InstanceId + "^" + EmrDocId;		

	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EPRservice.Quality.SaveManualResult.cls",
		async: true,
		data: {
			"ChangeData":ChangeData,
		},
		success: function(d) {
			$.messager.alert("提示","评分成功！");
			$('#Save'+index).hide();
			$('#Error'+index).hide();
			$('#QualityData').datagrid({
				rowStyler: function (index, row) {
				if (row.ItemInDetail == 1) {
					return 'color:green;';
				}
				else if (row.ItemInAiResult == 1) {
					
				return 'color:red;';   
				}
				}
			});
			SetManualFlag(action)
		},
		error : function(d) { 
			$.messager.alert("提示","评分失败！");
		}
	});
}

function Error(index)
{
	ErrorIndex=index
	$("#content").dialog("open");
}

function InitErrorDialog()
{
	$("#content").dialog({
					width:300,    
				    modal:true ,
				    title:'反馈',
	});
	$("#Ok").click(function(){
		var index=ErrorIndex
		if (index==="") return
		var rows = $("#QualityData").datagrid("getRows");
		var row = rows[index];
		var EntryID = row.EntryID;
		var StructName = row.StructName;
		var Text=$("#ErrorText").val();
		var Input=EpisodeID+"^"+EntryID+"^"+StructName+"^"+SignUserID+"^"+Text;
		jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EPRservice.Quality.Ajax.CompositeResult.cls",
		async: true,
		data: {
			"Action":"SaveError",
			"Input":Input
			
		},
		success: function(d) {
			if (d=="-1"){
				$.messager.alert("提示","反馈失败！");
			}else if (d>0) {
				$.messager.alert("提示","反馈成功！");
				$("#content").dialog("close");		
				
				$('#QualityData').datagrid({
				rowStyler: function (index, row) {
				if (row.ItemInDetail == 1) {
					return 'color:green;';
				}
				else if (row.ItemInAiResult == 1) {	
					return 'color:red;';   
				}
				}
			});	
			}
		},
		error : function(d) { 
			$.messager.alert("提示","错误！");	
		}
		
	});
	$("#ErrorText").val("")
	ErrorIndex=""
	});
	$("#Cancel").click(function(){
		$("#content").dialog("close");	
		$("#ErrorText").val("")
	});		
}

function SetManualFlag(Status) {
	
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../web.eprajax.EPRSetManualFlag.cls",
		async: true,
		data: {
			EpisodeID:EpisodeID,
			SignUserID:SignUserID,
			Action:"Set",
			Status:Status,
			SSGroupID:SSGroupID
		},
		success: function(d) {
			if (d ==1 )
			{
				//$.messager.alert("提示","确认成功！");
				if (typeof window.parent.parent.doSearch == "function")
				{window.parent.parent.doSearch();}
				else if (typeof window.parent.parent.parent.doSearch == "function")
				{window.parent.parent.parent.doSearch();}
				return;
			}
		}
	});
			
}
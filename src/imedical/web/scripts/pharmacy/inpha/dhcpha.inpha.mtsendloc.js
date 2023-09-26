/*
模块:		移动药房
子模块:		移动药房-送药科室关联维护
Creator:	hulihua
CreateDate:	2016-10-07
*/
var currEditRow = "";
var combooption = {
	valueField :'value',    
	textField :'text',
	panelWidth:'230'
}

$(function(){
	InitWardLocList();
	InitSetSendLocList();
	$('#SetSendLoc').datagrid('loadData',{total:0,rows:[]});
	Query();
});

///科室列表
function InitWardLocList(){
	//定义columns
	var columns=[[
	    {field:'rowid',title:'ID',width:60,hidden:true},
	    {field:'LocDesc',title:'病区科室',width:350}
	]];  
    //定义datagrid	
    $('#WardList').datagrid({
        url:LINK_CSP+'?ClassName=web.DHCINPHA.MTCommon.CommonUtil&MethodName=GetLocByLocTypeList&LocType=W&params=^'+$('#CombPhaloc').combobox('getValue'),
        fit:true,
	    border:false,
	    singleSelect:true,
	    rownumbers:true,
	    nowrap:false,
        columns:columns,
        pageSize:100,  // 每页显示的记录条数
	    pageList:[100,300,500],   // 可以设置每页记录条数的列表
	    singleSelect:true,
	    loadMsg: '正在加载信息...',
	    pagination:true,
	    onLoadError:function(data){
			$.messager.alert("错误","加载数据失败,请查看错误日志!","warning");
			$('#WardList').datagrid('loadData',{total:0,rows:[]});
			$('#WardList').datagrid('options').queryParams.LocType=W; 
		},
		onDblClickRow:function () {
			Save();
		}		
    });
}

///已关联送药科室列表
function InitSetSendLocList(){
	//文本编辑格
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	//定义columns
	var columns=[[
	    {field:'rowid',title:'ID',width:30,hidden:true},
	    {field:'WardLoc',title:'病区科室',width:200},
	    {field:'Tselect',title:'是否送药',width:60,align:'center',
			formatter: function(value,row,index){
				if (value=="Y"){
	        		return '<img src="../scripts/dhcpha/img/ok.png" border=0/>';
	        	}
			}
		},
		{field:'TWardQue',title:'显示序号',width:60,align:'right',editor:textEditor},
		{field:'TSendFreqDesc',title:'送药频率描述',width:150,align:'center',editor:textEditor},
		{field:'TSendFreqFactor',title:'频率系数',width:60,align:'right',editor:textEditor},
		{field:'TSendFactor',title:'付数系数',width:100,align:'right',editor:textEditor}
	]];  
    //定义datagrid	
    $('#SetSendLoc').datagrid({    
        url:LINK_CSP+'?ClassName=web.DHCINPHA.MTSendLoc.SendLocQuery&MethodName=GetSendLocList',
        fit:true,
	    border:false,
	    singleSelect:true,
	    rownumbers:true,
	    nowrap:false,
        columns:columns,
        pageSize:100,  // 每页显示的记录条数
	    pageList:[100,300,500],   // 可以设置每页记录条数的列表
	    singleSelect:true,
	    loadMsg: '正在加载信息...',
	    pagination:true,
	    onLoadError:function(data){
			//$.messager.alert("错误","加载数据失败,请查看错误日志!","warning")
			$('#SetSendLoc').datagrid('loadData',{total:0,rows:[]});
			$('#SetSendLoc').datagrid('options').queryParams.params = ""; 
		},    
		onLoadSuccess: function(){
			if (currEditRow!=undefined){
				$('#SetSendLoc').datagrid('endEdit', currEditRow);
				currEditRow = undefined
			}
		},
		onDblClickRow:function () {
			Delete();
		},
		onClickCell: function (rowIndex, field, value) {
            if (field=="WardLoc"){return;}
			if(field=="Tselect"){
				//var subrowdata=$("#SetSendLoc").datagrid('getSelected'); //Huxt 2020-02-21
				var rowsData = $('#SetSendLoc').datagrid('getRows');
				var subrowdata = rowsData[rowIndex];
				if((typeof subrowdata == "undefined")||(subrowdata == null)||(subrowdata == "")){
					$.messager.alert("提示","未选中要维护的记录!","info")
					return;
				}
				var phslid=subrowdata.rowid;
				var sendflag="Y";
				if (value=="Y"){
					sendflag="N";
				}
				var retValue=tkMakeServerCall("web.DHCINPHA.MTSendLoc.SendLocQuery","UpdateSendFlag",phslid,sendflag);
				if (retValue==-1){
					$.messager.alert("提示","该病区没有关联关系!","info")
					return;	
				}else if (retValue==-2){
					$.messager.alert("提示","没有选中是否送药!","info")
					return;	
				}else if (retValue==-3){
					$.messager.alert("提示","更新表结构失败!","info")
					return;	
				}
				$('#SetSendLoc').datagrid('updateRow',{
					index: rowIndex,
					row: {Tselect:sendflag}
				});
			}else{
				if (rowIndex != currEditRow) {
		        	if (endEditing(field)) {
						$("#SetSendLoc").datagrid('beginEdit', rowIndex);
						var editor = $('#SetSendLoc').datagrid('getEditor', {index:rowIndex,field:field});
			     	    editor.target.focus();
			     	    editor.target.select();
						$(editor.target).bind("blur",function(){
		                	endEditingdt(field);      
		            	});
						currEditRow=rowIndex;  
		        	}
				} 
			}
		}
    });
}

///验证输入数值的合法性
var endEditingdt = function (field) {
    if (currEditRow == undefined) { return true };
    if ($('#SetSendLoc').datagrid('validateRow', currEditRow)) {
        var ed = $('#SetSendLoc').datagrid('getEditor', { 
        	index: currEditRow, 
        	field: field
        });
        
		var selecteddata = $('#SetSendLoc').datagrid('getRows')[currEditRow]; 
		var phslid=selecteddata["rowid"];
		
		var wardque=selecteddata["TWardQue"];
		if (wardque == undefined) {wardque=""};
		
		var sendfreqdesc=selecteddata["TSendFreqDesc"];
		if (sendfreqdesc == undefined) {sendfreqdesc=""};
		
		var sendfreqfac=selecteddata["TSendFreqFactor"];
		if (sendfreqfac == undefined) {
			sendfreqfac="";
		}else if(sendfreqdesc == "全送"){
			sendfreqfac=1000;
		};
		var sendfactorfac=selecteddata["TSendFactor"];
		if (sendfactorfac == undefined) {sendfactorfac=""};
		
        var inputtxt=$(ed.target).val();
        $('#SetSendLoc').filter(":contains('2')").addClass("promoted")
        var detaildata="";
        if (field=="TSendFreqFactor"){
		    if (inputtxt<0){ 
		    	$.messager.alert('错误提示',"第 "+'<span style="color:red;font-weight:bold;border-bottom: 5px solid #E6EEF8" >'+ (currEditRow+1)+'</span>'+" 行频率系数不能小于0!","info");
		    	return false;
		    }
			$('#SetSendLoc').datagrid('updateRow',{
				index: currEditRow,
				row: {TSendFreqFactor:inputtxt}
			});
			detaildata=phslid+"^"+sendfreqdesc+"^"+inputtxt+"^"+sendfactorfac+"^"+wardque;
        }else if(field=="TSendFreqDesc"){
	       	if ((inputtxt=="")||((inputtxt==null))){ 
		    	$.messager.alert('错误提示',"第 "+'<span style="color:red;font-weight:bold;border-bottom: 5px solid #E6EEF8" >'+ (currEditRow+1)+'</span>'+" 行送药频率描述不能为空!","info");
		    	return false;
		    }
			$('#SetSendLoc').datagrid('updateRow',{
				index: currEditRow,
				row: {TSendFreqDesc:inputtxt}
			});
	        detaildata=phslid+"^"+inputtxt+"^"+sendfreqfac+"^"+sendfactorfac+"^"+wardque;
	    }else if(field=="TWardQue"){
	       	if (inputtxt<0){ 
		    	$.messager.alert('错误提示',"第 "+'<span style="color:red;font-weight:bold;border-bottom: 5px solid #E6EEF8" >'+ (currEditRow+1)+'</span>'+" 行显示序号不能小于0!","info");
		    	return false;
		    }
			$('#SetSendLoc').datagrid('updateRow',{
				index: currEditRow,
				row: {TWardQue:inputtxt}
			});
	        detaildata=phslid+"^"+sendfreqdesc+"^"+sendfreqfac+"^"+sendfactorfac+"^"+inputtxt;
	    }else{
			$('#SetSendLoc').datagrid('updateRow',{
				index: currEditRow,
				row: {TSendFactor:inputtxt}
			});
	        detaildata=phslid+"^"+sendfreqdesc+"^"+sendfreqfac+"^"+inputtxt+"^"+wardque;
	    }
		savedata(detaildata);
        $('#SetSendLoc').datagrid('endEdit', currEditRow);
        currEditRow = undefined;
        Query();
        return true;
    } else {
        return false;
    }
}

///送药频次和频次系数维护
function savedata(detaildata){
	var retValue=tkMakeServerCall("web.DHCINPHA.MTSendLoc.SendLocQuery","UpdateSendFreqInfo",detaildata);
	if (retValue==-1){
		$.messager.alert("提示","该病区没有关联关系!","info")
		return;	
	}else if (retValue==-2){
		$.messager.alert("提示","没有更新配置信息!","info")
		return;	
	}else if (retValue==-3){
		$.messager.alert("提示","更新表结构失败!","info")
		return;	
	}
}

///药房送药科室保存
function Save(){
	var phlocdr=$('#CombPhaloc').combobox('getValue');
	var row =$("#WardList").datagrid('getSelected');
	var wardid=row.rowid;
	var input=phlocdr+"^"+wardid;
	var data=tkMakeServerCall("web.DHCINPHA.MTSendLoc.SendLocQuery","Save","",input);
	if(data>0){
		$.messager.alert('提示','保存成功');			
	}else if(data==-1){
		$.messager.alert('提示','药房科室为空');	
	}else if(data==-2){
		$.messager.alert('提示','病区科室为空');	
	}else if(data==-3){
		$.messager.alert('提示','已经存在送药关系');	
	}else if(data==-4){
		$.messager.alert('提示','操作表失败');	
	}else{
		$.messager.alert('提示','保存失败:'+data);
	}
	$("#SetSendLoc").datagrid('reload');
	Query();	
}

///药房送药科室查询 (两个列表同时查询 Huxt 2020-02-19)
function Query(){
	var phlocdr = $('#CombPhaloc').combobox('getValue');
	if (phlocdr==""||phlocdr==null){
		//$.messager.alert('提示',"查询时药房不能为空!","info");
		return;
	}
	var params = phlocdr;
	$('#SetSendLoc').datagrid('load',{params:params});
	InitWardLocList(); //查询病区
}

///药房送药科室删除
function Delete(){
	if ($("#SetSendLoc").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个关联明细删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
		if (r){
			var row =$("#SetSendLoc").datagrid('getSelected');     
			runClassMethod("web.DHCINPHA.MTSendLoc.SqlDbSendLoc","Delete",{'Input':row.rowid},function(data){ $('#SetSendLoc').datagrid('load'); })
		}
		Query();
	});
}
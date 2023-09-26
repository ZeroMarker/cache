var arc="";


$(function(){
//给描述绑定一个回车事件
$('#params').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            //queryAdrPatImpoInfo(this.id+"^"+$('#'+this.id).val()); //调用查询
           commonQuery(); //调用查询           
        }
    });

// 查询按钮绑定单击事件
$('#find').bind('click',function(event){
         commonQuery(); //调用查询
    })
    
//重置按钮绑定单击事件
$('#reset').bind('click',function(event){
		$('#params').val("");
		arc="";         //  qunianpeng  2016-07-15
		commonQuery(); //调用查询
	})
    
});
//查询
function commonQuery(){
	var params=$('#params').val();
	$('#datagrid').datagrid('load',{params:params})
	}
    
function onClickRow(index,row){
	arc=row.arcimid;
	$('#discdatagrid').datagrid('load',{pointer:row.arcimid});
}


function addRow(){
	
	if(arc==""){
		$.messager.alert('提示','请先选择检查项目')
		return
	}
	// sufan 由于双击时，关闭，再点增加，不可编辑
	var e = $("#discdatagrid").datagrid('getColumnOption', 'PartNum');
	e.editor = {type:'numberbox',options:{required:true,min:0}};
	var e = $("#discdatagrid").datagrid('getColumnOption', 'Discount');
	e.editor = {type:'numberbox',options:{required:true,min:0,precision:4,max:1}};
	var e = $("#discdatagrid").datagrid('getColumnOption', 'StartDate');
	e.editor = {type:'datebox',options:{required:true}};
	var e = $("#discdatagrid").datagrid('getColumnOption', 'OutFlag');
	e.editor = {type:'combobox',options:{
										valueField:'value',
										textField:'text',
										url:'dhcapp.broker.csp?ClassName=web.DHCAPPArcDisc&MethodName=listOutFlag',
										required:true}
									};
	commonAddRow({'datagrid':'#discdatagrid',value:{'ADArcDr':arc,'OutFlag':0,'Discount':1,'StartDate':new Date().Format("yyyy-MM-dd")}})
}

/// sufan 2017-04-13  保存时，有重复或冲突数据，给出提示
function save()
{
	if(editIndex>="0"){
		$("#discdatagrid").datagrid('endEdit', editIndex);
	}
	var rowsData = $("#discdatagrid").datagrid('getChanges');
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		var tmp=rowsData[i].ID +"^"+ arc +"^"+ rowsData[i].PartNum +"^"+ rowsData[i].Discount +"^"+ rowsData[i].StartDate +"^"+ rowsData[i].EndDate +"^"+  rowsData[i].OutFlag;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//保存前判断是否给出提示
	runClassMethod("web.DHCAPPArcDisc","PromptData",{"params":params},function(String){
		if(String==0)
		{
			savedisc();  ///调用保存函数
		}else
		{
			var  Tmpstr=String.split("&");
			var TempData=Tmpstr[0].split("!")
				if (TempData[1] == "-3"){
					$.messager.confirm("提示", "该打折部位已存在，您确定保存数据吗？", function (res) {//提示是否删除
					if (res)
					 {
							savedisc(); ///调用保存函数
						}
					$('#discdatagrid').datagrid('reload')
				});
			}
		 }
	},"text",false);
}	
function savedisc(){
		saveByDataGrid("web.DHCAPPArcDisc","save","#discdatagrid",function(data){
		if(data==0){
			$.messager.alert('提示','保存成功')
		}else if(data==-11){
			$.messager.alert('提示','开始时间大于结束时间')
		}else if(data==-101){
			$.messager.alert('提示','前面部位的打折系数不能低于后面部位的打折系数,请核实!')
		}else{
			$.messager.alert('提示','保存失败:'+data)
		}
		$('#discdatagrid').datagrid('reload')
	})
}

function onClickRowDisc(index,row){
	// sufan  2017-03-10  双击时，关闭编辑
	var e = $("#discdatagrid").datagrid('getColumnOption', 'PartNum');
	e.editor = {};
    var e = $("#discdatagrid").datagrid('getColumnOption', 'Discount');
	e.editor = {};
	var e = $("#discdatagrid").datagrid('getColumnOption', 'StartDate');
	e.editor = {};
	var e = $("#discdatagrid").datagrid('getColumnOption', 'OutFlag');
	e.editor = {};
	CommonRowClick(index,row,"#discdatagrid");
}
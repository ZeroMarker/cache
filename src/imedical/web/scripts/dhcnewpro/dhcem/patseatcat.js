/// Creator: zhaowuqiang
/// CreateDate: 2016-12-14
//  Descript:座位类别维护维护

var editRow="",editparamRow="",clicknum="";  //当前编辑行号
var dataArray=[{"value":"Y","text":"是"},{"value":"N","text":"否"}]; //hxy 2018-10-12
$(function(){	
	hospComp = GenHospComp("DHC_EmPatSeatCat");  //hxy 2020-05-22 st
	hospComp.options().onSelect = function(){///选中事件
		findSeatStatus();
	}
    var HospDr=hospComp.getValue();//ed
    
	var Flageditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			data:dataArray,
			valueField: "value", 
			textField: "text",
			editable:false, //huaxiaoying 2017-01-06
			onSelect:function(option){
				///设置类型值
				var ed=$("#seatcatlist").datagrid('getEditor',{index:editRow,field:'enabled'});
				
				//$(ed.target).combobox('setValue', option.text);  //设置是否可用
			} 
		}

	}
	
	var Hospitaleditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			//url:LINK_CSP+"?ClassName=web.DHCEMPatSeatCat&MethodName=SelHosDesc",
			url:LINK_CSP+"?ClassName=web.DHCEMCommonUtil&MethodName=GetHospDs", //huaxiaoying 2016-01-06
			required:false, //hxy 2019-09-18 true
			editable:false, //huaxiaoying 2017-01-06
			panelHeight:"200",  //设置容器高度自动增长
			onSelect:function(option){
				var ed1=$("#seatcatlist").datagrid('getEditor',{index:editRow,field:'hospId'});  
				$(ed1.target).val(option.value);    //	QQA 2017-1-12  设置级联
			} 
		}
	}
	
	// 定义columns
	var columns=[[
		{field:"seatcode",title:'代码',width:100,align:'center',editor:{type:'validatebox',options:{required:true}}}, 
		{field:"seatdesc",title:'描述',width:130,align:'center',editor:{type:'validatebox',options:{required:true}}},
		{field:"seatcolor",title:'颜色',width:130,align:'center',editor:{type:'colorpicker'},formatter:formatterSeatColor,styler:stylerSeatColor},
		{field:"seatcolorvalue",title:'颜色2',width:130,align:'center',editor:{type:'validatebox',options:{}},hidden:true},
		{field:"hosdesc",title:'医院',width:220,align:'center',editor:Hospitaleditor,hidden:true}, //hxy 2019-09-18
		{field:'enabled',title:'是否可用',width:130,align:'center',editor:Flageditor,
				formatter:function(value,row,index){
					if (value=='Y'){return '是';} 
					else {return '否';}
				}}, 
		{field:'hospId',title:'医院ID',width:130,align:'center',hidden:true,editor:{type:'validatebox',options:{required:false}}},   //QQA 隐藏字段获取医院ID //hxy 2019-09-19 去掉必填
		{field:"seatid",title:'ID',width:70,align:'center',editor:{type:'validatebox'},hidden:true}
	]];
	// 定义datagrid
	$('#seatcatlist').datagrid({
		title:'',
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatSeatCat&MethodName=QuerySeatCat&HospDr='+HospDr, //huaxiaoying 2017-1-4 规范名字 //hxy 2020-05-22 &HospDr='+HospDr
		fit:true,
		border:false,//hxy 2018-10-12
		rownumbers:false,
		columns:columns,
		pageSize:30,  // 每页显示的记录条数
		pageList:[30,60],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    	clicknum=rowIndex;
            if(editRow>="0"){
				$("#seatcatlist").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
			}
            $("#seatcatlist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	});
 
 	//按钮绑定事件
    $('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
    
    //同时给代码和描述绑定回车事件
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            //findAdrStatus(this.id+"^"+$('#'+this.id).val()); //调用查询
            findSeatStatus(); //调用查询
        }
    });
    
    // 查找按钮绑定单击事件
   /* $('#find').bind('click',function(event){
         findSeatStatus(); //调用查询
    });
 */
})

// 插新行
function insertRow()
{
	clicknum="";
	var HospDr=hospComp.getValue(); //hxy 2020-05-22
	if(editRow>="0"){
		$("#seatcatlist").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	 
	$("#seatcatlist").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {seatid: '',seatcode:'',seatdesc: '',rowsData:'',hosdesc:HospDr,enabled:'Y',hospId:HospDr} //huaxiaoying 2017-01-06 //2019-07-26 LgHospID //hxy 2020-05-22 LgHospID->HospDr
		//row: {seatid: '',seatcode:'',seatdesc: '',rowsData:'',hosdesc:LgHospID,enabled:'Y',hospId:LgHospID} //huaxiaoying 2017-01-06 //2019-07-26 LgHospID

	});
            
	$("#seatcatlist").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

// 删除选中行
function deleteRow()
{
	var rowsData = $("#seatcatlist").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCEMPatSeatCat","DelSeatCat",{"params":rowsData.seatid},function(ret){
					if(ret==-1024){
						$.messager.alert("提示","请先删除已经使用此类别的输液室座位！")
					}else{
						$('#seatcatlist').datagrid('reload'); //重新加载
					}
				},"text")
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

// 保存编辑行
function saveRow()
{
	if(editRow>="0"){
		$("#seatcatlist").datagrid('endEdit',editRow);
	}
	
	var rowsData = $("#seatcatlist").datagrid('getChanges');

	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if((rowsData[i].seatcode=="")||(rowsData[i].seatdesc=="")){ //hxy 2019-09-18
		//if((rowsData[i].seatcode=="")||(rowsData[i].seatdesc=="")||(rowsData[i].hosdesc=="")){ //huaxiaoying 2017-01-06
			$.messager.alert("提示","请编辑必填数据!"); 
			return false;
		}
		var tmp=rowsData[i].seatid +"^"+ rowsData[i].seatcode +"^"+ rowsData[i].seatdesc +"^"+ rowsData[i].enabled +"^"+ rowsData[i].hospId+"^"+rowsData[i].seatcolorvalue;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//保存数据
	runClassMethod("web.DHCEMPatSeatCat","SaveSeatCat",{"params":params},function(jsonString){
		if(jsonString==0){
			$.messager.alert("提示","保存成功!"); 
			$('#seatcatlist').datagrid('reload'); //重新加载
		}else if(jsonString==-96){
			$.messager.alert("提示","代码重复!"); 
			$('#seatcatlist').datagrid('reload'); //重新加载
		}else if(jsonString==-95){
			$.messager.alert("提示","描述录入重复!"); 
			$('#seatcatlist').datagrid('reload'); //重新加载
		}else{
			$.messager.alert("提示","保存失败!"); 
			$('#seatcatlist').datagrid('reload'); //重新加载
		}
	});
}

function formatterSeatColor(value,row,index){
	if((value=="")||(value==undefined)){
		value=row.seatcolorvalue;
	}
	return value;
}

function stylerSeatColor(value,row,index){
	var ret="";
	if((value=="")||(value==undefined)){
		value=row.seatcolorvalue;
	}
	if(value!=""){
		ret = "background-color:"+value;
	}
	return ret
}
// 编辑格
var texteditor={
	type: 'text',//设置编辑格式
	options: {
		required: true //设置编辑规则属性
	}
}

// 查询
function findSeatStatus()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+"^"+desc;
	var HospDr=hospComp.getValue();
	$('#seatcatlist').datagrid('load',{params:params,HospDr:HospDr}); 
}


//增加编辑器
$.extend($.fn.datagrid.defaults.editors, {
	colorpicker: {
		init: function(container, options){
			var input = $('<input type="text" style="height:22px"/>').appendTo(container);
			return input.ColorPicker({
				onSubmit: function(hsb, hex, rgb, el) {
					$(el).val(hex);
					$(el).ColorPickerHide();
					var ed=$("#seatcatlist").datagrid('getEditor',{index:editRow,field:'seatcolorvalue'});
					$(ed.target).val("#"+hex);
				},
				onBeforeShow: function () {
					$(this).ColorPickerSetColor(this.value);
				}
			}).bind('keyup', function(){
				$(this).ColorPickerSetColor(this.value);
				var ed=$("#seatcatlist").datagrid('getEditor',{index:editRow,field:'seatcolorvalue'});
				$(ed.target).val("#"+this.value);
			});
		},
		destroy: function(target){
			
		},
		getValue: function(target){
			
		},
		setValue: function(target, value){	
			if((value=="")||(value==undefined)){
				if(clicknum>="0"){
					var tbed=$('#seatcatlist').datagrid('getRows')[clicknum];
					value=tbed.seatcolorvalue;
				}
			}
			if(value!=""&&value!=undefined) $(target).val(value.split("#")[1]);
		},
		resize: function(target, width){
			
		}
	}
});

/**
 * 医保字典维护JS
 * Zhan 201408
 * 版本：V1.0
 * easyui版本:1.3.2
 */
var cmenu;
var grid;
var selRowid="";
//var ROOTID='TEST2';	//测试用
var searchParam = {}; 
var seldictype=""; 
var tmpselRow=-1;
$(function(){
	
	GetjsonQueryUrl();
	//初始化datagrid
	grid=$('#dg').datagrid({
		idField:'dgid',
		iconCls: 'icon-save',
		rownumbers:true,
		width: '100%',
		height: 330,
		striped:true,
		fitColumns: true,
		singleSelect: true,
		columns:[[
			{field:'Rowid',title:'Rowid',width:10,hidden:true},
			{field:'INDIDDicType',title:'字典类别',width:60},
			{field:'INDIDDicCode',title:'代码',width:50},
			{field:'INDIDDicDesc',title:'名称',width:120},
			{field:'INDIDDicBill1',title:'医保代码',width:80},
			{field:'INDIDDicBill2',title:'医保描述',width:150},
			{field:'INDIDDicDemo',title:'备注',width:120,align:'center'}
		]],
		pageSize: 10,
		pagination:true,
        onClickRow : function(rowIndex, rowData) {
	        if(tmpselRow==rowIndex){
		        clearform("")
		        tmpselRow=-1
		        $(this).datagrid('unselectRow',rowIndex)
		    }else{
			    fillform(rowIndex,rowData)
			    tmpselRow=rowIndex
			}
            
        },
        onUnselect: function(rowIndex, rowData) {
        	//alert(rowIndex+"-"+rowData.itemid)
        }
	});
	//grid.datagrid({loadFilter:pagerFilter}).datagrid('loadData', getData());	//测试用

	//下方的panel
	$('#sourth').panel({   
		width:'100%',   
		height:200
	});  
	//$('#sourth').append(formstr)
	/*
	$('#diccbx').combobox({   
	    url:CSPURL + 'cspfile',
	    valueField:'id',   
	    textField:'text',
	    onSelect: function(rec){  
	    	//alert(rec.text)
	    	Querydic(rec)
	    }
	});  
	*/
	//var dicurl=CSPURL+'insudicdata.csp?ARGUS='+ROOTID+SplCode+'INSUDICSYS'+SplCode+'SYS'
	var dicSelid=0
	var dicurl=jsonQueryUrl+'web.INSUDicDataCom'+SplCode+"GetDicJSONInfo"+SplCode
	var diccombox=$('#diccbx').combogrid({  
		//idField: 'diccbxid', 
	    panelWidth:520,   
	    //panelHeight:238,  
	    idField:'INDIDDicCode',   
	    textField:'INDIDDicDesc', 
        //rownumbers:true,
        pagination: false,
        url:dicurl,
        delay:1000,
		//queryParams:searchParam,//当请求远程数据时，发送的额外参数  
	    columns:[[   
	        {field:'INDIDDicCode',title:'代码',width:160},  
	        {field:'INDIDDicDesc',title:'名称',width:210},
	        {field:'INDIDDicDemo',title:'备注',width:110}
	        
	    ]],
	    //fitColumns: true,
        keyHandler:{  
			up: function(){},  
			down: function(){},  
			enter: function(){ 
				//getSearchParam();  
				//searchParam.key = encodeURI(decodeURIComponent($.trim(diccombox.combogrid('getText')))); 
				//searchParam.key = encodeURI($.trim(diccombox.combogrid('getText')));  
				//searchParam.key =('SYS'+ArgSpl+$.trim(diccombox.combogrid('getText')))
				//alert(searchParam)
				
				//diccombox.combogrid('grid').datagrid({ url: (dicurl+'SYS'+ArgSpl+$.trim(diccombox.combogrid('getText'))), queryParams: { qid:1}});
				
				//var cbxgrid = diccombox.combogrid('grid');  
				//$(cbxgrid).datagrid('options').url= dicurl;  
				//$(cbxgrid).datagrid('load');  
				
			},  
			query:function(q){ 
				//$(this).combogrid('grid').datagrid('unselectAll')
				var tmpq=$(this).combogrid('getText')
				//alert(dicSelid+"_"+tmpq)
				$(this).combogrid('grid').datagrid('unselectRow',dicSelid);
				dicSelid=0
				if(tmpq!="")$(this).combogrid('setText',tmpq)
				$(this).combogrid('grid').datagrid({ url: (dicurl+'SYS'+ArgSpl+cspEscape($.trim(q))+ArgSpl+"1"), queryParams: { qid:1}});
				return true;  
			}  
		},
		onSelect: function (record,selobj) {              //选中处理
			dicSelid=record
			if(selobj.INDIDDicDemo!=null){
				var tmpArr=selobj.INDIDDicDemo.split("|")
				if(tmpArr.length>5){
					var tmpstr=tmpArr[5]
					var usercode=session['LOGON.USERCODE']
					if((tmpstr!="")&(tmpstr.indexOf(usercode)==-1)){
						disinput("disabled")
					}else{
						disinput(false)
					}
				}else{disinput(false)}
			}else(disinput(false))
			Querydic($('#diccbx').combogrid('grid').datagrid('getSelected'),selobj);

		},
		onShowPanel:function(){
			$(this).combogrid('grid').datagrid('unselectAll')
			$(this).combogrid('grid').datagrid({ url: (dicurl+'SYS'+ArgSpl+cspEscape($(this).combogrid('getText'))+ArgSpl+"1"), queryParams: { qid:1}});
			/*
			if(""==$.trim($(this).combogrid('getText')))
			{
				//$(this).combogrid('clear')
				$(this).combogrid('grid').datagrid({ url: (dicurl+'SYS'+ArgSpl+ArgSpl+"1"), queryParams: { qid:1}});
			}
			*/
		}
	
	}); 
	/*
	var cbxpager =diccombox.combogrid('grid').datagrid('getPager');
    $(cbxpager).pagination({
	    showPageList:false,
	    displayMsg:'',
	    pageSize:6
	});
	*/
	//disinput(true);
	//授权管理
	if(BDPAutDisableFlag('btnAdd')!=true){$('btnAdd').linkbutton('disable');}
	if(BDPAutDisableFlag('btnAddup')!=true){$('btnAddup').linkbutton('disable');}
	if(BDPAutDisableFlag('btnUpdate')!=true){$('btnUpdate').linkbutton('disable');}
	if(BDPAutDisableFlag('btnDelete')!=true){$('btnDelete').linkbutton('disable');}

});
function getSearchParam(){  
	return searchParam;  
}  

//查询字典数据
function Querydic(rec,selobj){
	//alert(rec.INDIDDicCode)
	//queryParams参数可以提交到后台通过FormCollection获取 也可以Request["ProductName"]=?获取
	seldictype=cspEscape(rec.INDIDDicCode)
	if(('undefined'==seldictype)||(""==seldictype)) return
	//var tmpARGUS=ROOTID+SplCode+'INSUDICinfo'+SplCode+seldictype
	var tmpARGUS=jsonQueryUrl+'web.INSUDicDataCom'+SplCode+"GetDicJSONInfo"+SplCode+seldictype+ArgSpl+ArgSpl
	grid.datagrid('unselectAll')
	grid.datagrid({ url: tmpARGUS, queryParams: {qid:1}});
	grid.datagrid('getPager').pagination('select',1);
	//alert(selobj.INDIDDicDemo)
	var titleval="";
	var titleArr;
	titleval=selobj.INDIDDicDemo
	if(titleval==null){
		titleval="代码|名称|医保代码|医保描述|备注"
	}
	titleArr=titleval.split("|")	//代码|名称|医保代码|医保名称|备注|
	
	if(titleArr.length<5){return;}
	if(titleArr[0].length>0)$('#codelab').html(titleArr[0])
	if(titleArr[1].length>0)$('#desclab').html(titleArr[1])
	if(titleArr[2].length>0)$('#insucodelab').html(titleArr[2])
	if(titleArr[3].length>0)$('#insudesclab').html(titleArr[3])
	if(titleArr[4].length>0)$('#notelab').html(titleArr[4])
}
//增加记录
function AddDic(){

	clearform("")	//请输入信息
	//$.messager.alert('提示','填写数据后请点击"保存记录"按钮');   
}
//更新保存记录
function UpdateDic(){
	/*
	if($('#code')[0].isDisabled){
		$.messager.alert('提示','未修改!');   
		return;
	}
	*/
	
	//特殊字符^的处理
	$('#code').val($('#code').val().replace(/\^/g,""));
	$('#desc').attr("value",$('#desc').attr("value").replace(/\^/g,""));
	$('#insucode').attr("value",$('#insucode').attr("value").replace(/\^/g,""));
	$('#insudesc').attr("value",$('#insudesc').attr("value").replace(/\^/g,""));
	$('#note').attr("value",$('#note').attr("value").replace(/\^/g,""));
	
	if($('#code').val().indexOf("请输入")>=0 || $('#code').val()==""){$.messager.alert('提示','请输入信息后再保存!');return;}
	if($('#desc').val().indexOf("请输入")>=0 || $('#desc').val()==""){$.messager.alert('提示','名称不能为空!');return;}
	if((seldictype=="")||(seldictype=='undefined')){
		$.messager.alert('提示','请选择字典类别!');return;
	}
	
	var saveinfo=selRowid+"^"+cspUnEscape(seldictype)+"^"+$('#code').val()+"^"+$('#desc').attr("value")+"^"+$('#insucode').attr("value")+"^"+$('#insudesc').attr("value")+"^"+$('#note').attr("value");
	saveinfo=saveinfo.replace(/请输入信息/g,"")
	var savecode=tkMakeServerCall("web.INSUDicDataCom","Update","","",saveinfo)
	//alert(savecode)
	if(eval(savecode)>0){
		//$.messager.alert('提示','保存成功!');  
		grid.datagrid('reload')
		grid.datagrid('unselectAll')
		clearform("")
		MSNShow('提示','保存成功！',2000) 
	}else{
		if(eval(savecode)==-1001){
			$.messager.alert('提示','【'+$('#code').val()+'】此代码已存在相同记录!如果要更新内容请先查询出此代码的记录!');  
			return; 
		}
		$.messager.alert('提示','保存失败!');   
	}
}
//删除记录
function DelDic(){
	//if(BDPAutDisableFlag('btnDelete')!=true){$.messager.alert('提示','您无权限,请联系管理员授权!');return;}
	if(selRowid==""){$.messager.alert('提示','请选择要删除的记录!');return;}
	$.messager.confirm('请确认','你确认要删除这条记录吗?',function(fb){
		if(fb){
			var savecode=tkMakeServerCall("web.INSUDicDataCom","Delete","","",selRowid)
			if(eval(savecode)>0){
				$.messager.alert('提示','删除成功!');   
				grid.datagrid('reload')
				selRowid="";
				grid.datagrid("getPager").pagination('refresh');
				grid.datagrid('unselectAll')
			}else{
				$.messager.alert('提示','删除失败!');   
			}
		}else{
			return;	
		}
	});
	

}

function getcombogridValue(){ 
	//var grid=$("#cc").combogrid("grid");//获取表格对象 
	//var row = grid.datagrid('getSelected');//获取行数据 
	//alert("选择的grid中的数据如下：code:"+row.code+" name:"+row.name+" addr:"+row.addr+" col4:"+row.col4); 
} 

//填充下边的form
function fillform(rowIndex,rowData){
	selRowid=rowData.Rowid
	//disinput(true);
	$('#code').val(rowData.INDIDDicCode);
	$('#insucode').val(rowData.INDIDDicBill1);
	$('#desc').val(rowData.INDIDDicDesc);
	$('#insudesc').val(rowData.INDIDDicBill2);
	$('#note').val(rowData.INDIDDicDemo);

	//$('#note2').val(rowData.itemid);
}
//清除下边的form
function clearform(inArgs){
	
	$('#editinfo input').each(function(){        
		$(this).val(inArgs)
	})
	selRowid="";
	//disinput(false);
	/*
	$("#editinfo tr").find("td").each(function(i){
       if($(this).find("input[type='textbox']").length>0)
       {
           alert($(this).find("input[type='textbox']").val());
       }
       else if($(this).find("select").length>0)
       {
           alert($(this).find("select").val());
       }

     });
	*/
}
//改变下边显示框的编辑状态
function disinput(tf){
	//return;
	$('#code').attr("disabled",tf);
	$('#insucode').attr("disabled",tf);
	$('#desc').attr("disabled",tf);
	$('#insudesc').attr("disabled",tf);
	$('#note').attr("disabled",tf);
	$('#note2').attr("disabled",tf);

}



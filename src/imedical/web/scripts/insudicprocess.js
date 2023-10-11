/**
 * 医保接口流程字典配置JS
 * FileName:insudicprocess.js
 * Huang SF 2018-03-20
 * Update by tangzf 2019-8-7 多院区及HISUI改造
 * 版本：V1.0
 * hisui版本:0.1.0
 */
 
//全局变量
var cmenu;
var grid;
var selRowid="";
//var ROOTID='TEST2';	//测试用
var searchParam = {}; 
var seldictype=""; 
var tmpselRow=-1;
$(function(){
	
	// GetjsonQueryUrl();
	
	var dicSelid=0
	//初始化combogrid
	$HUI.combogrid("#diccbx",{  
		//idField: 'diccbxid', 
	    panelWidth:520,   
	    //panelHeight:238,  
	    idField:'INDIDDicCode',   
	    textField:'INDIDDicDesc', 
        //rownumbers:true,
        pagination: false,
        delay:500,
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
			},  
			query:function(q){ 
				$(this).combogrid('grid').datagrid('unselectAll');
				//异步加载
				$.cm({
					ClassName:"web.INSUDicDataCom",
					QueryName:"QueryDicSys",
					CodeAndDesc:q,
					queryFlag:"PRO",
					rows:1000
				},function(jsonData){
					$('#diccbx').combogrid('grid').datagrid('loadData',jsonData.rows);
					$('#diccbx').combogrid('setText',q);
				}); 
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
			clearform();
			Querydic($('#diccbx').combogrid('grid').datagrid('getSelected'),selobj);
		},
		onShowPanel:function(){	
			/*$(this).combogrid('grid').datagrid('unselectAll'); tangzf 2020-5-26 -
			var comText=$.trim($(this).combogrid('getText'));
			//异步加载
			$.cm({
				ClassName:"web.INSUDicDataCom",
				QueryName:"QueryDicSys",
				CodeAndDesc:comText,
				queryFlag:"PRO",
				rows:1000
			},function(jsonData){		
				$('#diccbx').combogrid('grid').datagrid('loadData',jsonData.rows);
				$('#diccbx').combogrid('setText',comText);
			}); */
		}
	
	}); 
	
	//初始化datagrid
	$HUI.datagrid("#dg",{
		fit: true,
		//idField:'dgid',
		iconCls: 'icon-save',
		rownumbers:true,
		width: '100%',
		striped:true,
		fitColumns:true,
		singleSelect: true,
		autoRowHeight:false,
		columns:[[
			//{field:'cType',title:'字典类别',width:55},
			{field:'cCode',title:'代码',width:80},
			{field:'cDesc',title:'名称',width:150},
			//{field:'cBill1',title:'医保代码',width:80},
			//{field:'cBill2',title:'医保描述',width:150},
			{field:'cDemo',title:'备注',width:150,align:'center',showTip:true},
			/*{field:'DicAuthorityFlag',title:'授权标志',width:50},
			{field:'DicOPIPFlag',title:'门诊住院标志',width:50},
			{field:'selected',title:'默认使用标志',width:50,formatter:function(val,index,rowdData){
				if(val){
					return "Y"	
				}else{
					return "N"	
				}
			}},
			{field:'DicUseFlag',title:'使用标志',width:50},
			{field:'DicRelationFlag',title:'关联其他字典标志',width:50},
			{field:'id',title:'id',width:10,hidden:true}
			{field:'Rowid',title:'Rowid',width:10,hidden:true},
			{field:'INDIDDicType',title:'字典类别',width:55,hidden:true},
			{field:'INDIDDicCode',title:'代码',width:60},
			{field:'INDIDDicDesc',title:'名称',width:80},
			{field:'INDIDDicBill1',title:'医保代码',width:80,hidden:true},
			{field:'INDIDDicBill2',title:'医保描述',width:150,hidden:true},
			{field:'INDIDDicDemo',title:'备注',align:'center',width:250},
			{field:'INDIDDicAuthorityFlag',title:'授权标志',width:50,hidden:true},
			{field:'INDIDDicOPIPFlag',title:'门诊住院标志',width:50,hidden:true},
			{field:'INDIDDicDefaultFlag',title:'默认使用标志',width:50,hidden:true},
			{field:'INDIDDicUseFlag',title:'使用标志',width:50,hidden:true},
			{field:'INDIDDicRelationFlag',title:'关联其他字典标志',width:50,hidden:true}*/
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
	//登记号回车查询事件
	$("#dicDemo").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			Querydic();
		}
	});
	//授权管理
	if(BDPAutDisableFlag('btnAdd')!=true){$('btnAdd').linkbutton('disable');}
	if(BDPAutDisableFlag('btnAddup')!=true){$('btnAddup').linkbutton('disable');}
	if(BDPAutDisableFlag('btnUpdate')!=true){$('btnUpdate').linkbutton('disable');}
	if(BDPAutDisableFlag('btnDelete')!=true){$('btnDelete').linkbutton('disable');}
	$("#dg").datagrid("loadData",{"total":"0",rows:[]}); //Zhan 20181206解决初始化时显示10条记录问题,后期HISUI修改后可注释此行
});

function getSearchParam(){  
	return searchParam;  
}  

//查询字典数据
function Querydic(){
	//alert(rec.INDIDDicCode)
	//queryParams参数可以提交到后台通过FormCollection获取 也可以Request["ProductName"]=?获取
	// tangzf 2020-6-17 使用HISUI接口 加载数据
	var QueryParam={
		ClassName:'web.INSUDicDataCom' ,
		QueryName: 'QueryDicByTypeOrCodeDesc',
		Type :$('#diccbx').combobox('getValue'), 
		keyDemo:getValueById('dicDemo'),
		HospDr : PUBLIC_CONSTANT.SESSION.HOSPID
	}
	loadDataGridStore('dg',QueryParam);
	seldictype = $('#diccbx').combobox('getValue');
	/*
	if(('undefined'==seldictype)||(""==seldictype)) return
	//var tmpARGUS=ROOTID+SplCode+'INSUDICinfo'+SplCode+seldictype
	var tmpARGUS=jsonQueryUrl+'web.INSUDicDataCom'+SplCode+"GetDicJSONInfo"+SplCode+seldictype+ArgSpl+ArgSpl
	$("#dg").datagrid('unselectAll')
	$("#dg").datagrid({ url: tmpARGUS, queryParams: {qid:1}});
	$("#dg").datagrid('getPager').pagination('select',1);
	//alert(selobj.INDIDDicDemo)
	var titleval="";
	var titleArr;
	titleval=selobj.INDIDDicDemo
	if(titleval==null){
		titleval="代码|名称|备注|"
	}
	titleArr=titleval.split("|")	//代码|名称|医保代码|医保名称|备注|
	
	if(titleArr.length<3){return;}
	if(titleArr[0].length>0)$('#codelab').html(titleArr[0])
	if(titleArr[1].length>0)$('#desclab').html(titleArr[1])
	if(titleArr[2].length>0)$('#notelab').html(titleArr[3])*/
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
	$('#desc').val($('#desc').val().replace(/\^/g,""));
	$('#note').val($('#note').val().replace(/\^/g,""));
		
	if($('#code').val().indexOf("请输入")>=0 || $('#code').val()==""){$.messager.alert('提示','请输入信息后再保存!');return;}
	if($('#desc').val().indexOf("请输入")>=0 || $('#desc').val()==""){$.messager.alert('提示','名称不能为空!');return;}
	if((seldictype=="")||(seldictype=='undefined')){
		$.messager.alert('提示','请选择字典类别!');return;
	}
	
	var saveinfo=selRowid+"^"+seldictype+"^"+$('#code').val()+"^"+$('#desc').val()+"^^^"+$('#note').val();
	saveinfo=saveinfo.replace(/请输入信息/g,"")
	///alert(saveinfo)
	var savecode=tkMakeServerCall("web.INSUDicDataCom","UpdateIn","","",saveinfo)
	//alert(savecode)
	if(eval(savecode)>0){
		//$.messager.alert('提示','保存成功!');  
		$("#dg").datagrid('reload')
		$("#dg").datagrid('unselectAll')
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
	if(selRowid==""|| selRowid<0 || !selRowid){$.messager.alert('提示','请选择要删除的记录!','info');return;}
	$.messager.confirm('请确认','你确认要删除这条记录吗?',function(fb){
		if(fb){
			var savecode=tkMakeServerCall("web.INSUDicDataCom","Delete","","",selRowid)
			if(eval(savecode)>0){
				$.messager.alert('提示','删除成功!');   
				$("#dg").datagrid('reload')
				selRowid="";
				$("#dg").datagrid("getPager").pagination('refresh');
				$("#dg").datagrid('unselectAll')
			}else{
				$.messager.alert('提示','删除失败!');   
			}
		}else{
			return;	
		}
	});
	
	var okSpans=$(".l-btn-text");
	var len=okSpans.length;
	for(var i=0;i<len;i++){
		var $okSpan=$(okSpans[i]);
		var okSpanHtml=$okSpan.html();
		if(okSpanHtml=="Cancel"|| okSpanHtml=="取消"){
			$okSpan.parent().parent().trigger("focus");
		}
	}

}

function getcombogridValue(){ 
	//var grid=$("#cc").combogrid("grid");//获取表格对象 
	//var row = grid.datagrid('getSelected');//获取行数据 
	//alert("选择的grid中的数据如下：code:"+row.code+" name:"+row.name+" addr:"+row.addr+" col4:"+row.col4); 
} 

//填充下边的form
function fillform(rowIndex,rowData){
	selRowid=rowData.id
	//disinput(true);
	$('#code').val(rowData.cCode);
	$('#desc').val(rowData.cDesc);
	$('#note').val(rowData.cDemo);
}
//清除下边的form
function clearform(inArgs){
	
	$('#editForm1 input').each(function(){        
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
	$('#desc').attr("disabled",tf);
	$('#note').attr("disabled",tf);

}
function selectHospCombHandle(){
	$('#diccbx').combogrid('grid').datagrid('unselectAll');
	setValueById('diccbx','');
	seldictype='';
	selRowid = '';
	selRowid = -1;
	//加载grid
	var selobj ={
			INDIDDicCode : '',
			INDIDDicDemo : null
	}
	Querydic(selobj,selobj);
	//异步加载
	$.cm({
		ClassName:"web.INSUDicDataCom",
		QueryName:"QueryDicSys",
		CodeAndDesc:'',
		queryFlag:"PRO",
		rows:1000
	},function(jsonData){		
		$('#diccbx').combogrid('grid').datagrid('loadData',jsonData.rows);
	});	
	
}
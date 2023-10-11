/**
 * 医保接口字典配置JS
 * FileName: insudicconf.js
 * Huang SF 2018-03-20
 * Update by tangzf 2019-8-7 多院区及HISUI改造
 * 版本：V1.0
 * hisui版本:0.1.0
 */
 
//全局变量
var selRowid="";
var seldictype = ""; 
var tmpselRow = -1;
var PassWardFlag = "N";
var PublicDataSwitchBox = "";
$(function(){
	
	//GetjsonQueryUrl();
	
	var dicSelid=0
	//初始化combogrid
	$HUI.combogrid("#diccbx",{  
		//idField: 'diccbxid', 
	    panelWidth:520,   
	    panelHeight:300,  
	    idField:'INDIDDicCode',   
	    textField:'INDIDDicDesc', 
        //rownumbers:true,
        pagination: false,
        delay:800,
	    columns:[[   
	        {field:'INDIDDicCode',title:'代码',width:160},  
	        {field:'INDIDDicDesc',title:'名称',width:210},
	        {field:'INDIDDicDemo',title:'备注',width:110}    
	    ]],
	    //fitColumns: true,
        keyHandler:{  
			up: function(){},  
			down: function(){},  
			enter: function(){},  
			query:function(q){ 
				$(this).combogrid('grid').datagrid('unselectAll');
				//异步加载
				$.cm({
					ClassName:"web.INSUDicDataCom",
					QueryName:"QueryDicSys",
					CodeAndDesc:q,
					queryFlag:"",
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
		}
	}); 
	
	//初始化combobox
	$HUI.combobox("#autFlag",{
		valueField:'cCode',
    	textField:'cCode',
    	panelHeight:100
	});

	//初始化datagrid
	$HUI.datagrid("#dg",{
		data:[],
		fit: true,
		//idField:'dgid',
		rownumbers:true,
		width: '100%',
		striped:true,
		fitColumns:true,
		singleSelect: true,
		autoRowHeight:false,
		columns:[[
			{field:'cType',title:'字典类别',width:80},
			{field:'cCode',title:'代码',width:80},
			{field:'cDesc',title:'名称',width:150},
			{field:'cBill1',title:'医保代码',width:80},
			{field:'cBill2',title:'医保描述',width:150},
			//{field:'cDemo',title:'备注',width:150,align:'center',showTip:true},
			{field:'cDemo',title:'备注',width:150,showTip:true},
			{field:'DicAuthorityFlag',title:'授权标志',width:50},
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
			/*{field:'INDIDDicType',title:'字典类别',width:55},
			{field:'INDIDDicCode',title:'代码',width:80},
			{field:'INDIDDicDesc',title:'名称',width:150},
			{field:'INDIDDicBill1',title:'医保代码',width:80},
			{field:'INDIDDicBill2',title:'医保描述',width:150},
			{field:'INDIDDicDemo',title:'备注',width:150,align:'center',showTip:true},
			{field:'INDIDDicAuthorityFlag',title:'授权标志',width:50},
			{field:'INDIDDicOPIPFlag',title:'门诊住院标志',width:50},
			{field:'INDIDDicDefaultFlag',title:'默认使用标志',width:50},
			{field:'INDIDDicUseFlag',title:'使用标志',width:50},
			{field:'INDIDDicRelationFlag',title:'关联其他字典标志',width:50},
			{field:'Rowid',title:'Rowid',width:10,hidden:true}*/
		]],
		pageSize: 30,
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
	// 同步刷新开关
	$HUI.switchbox('#csconflg',{
        onText:'是',
        offText:'否',
        onSwitchChange:function(e,obj){
			if(obj.value){
				var rtn = tkMakeServerCall("web.DHCBILLINSUCloudCommon","SetSessionData",""); //公有数据院区为空
			}else{
				var rtn = tkMakeServerCall("web.DHCBILLINSUCloudCommon","SetSessionData",PUBLIC_CONSTANT.SESSION.HOSPID);
			}
			selectHospCombHandle();
        },
        checked:false,
        size:'small',
    })
	// 提示信息
    $("#csconflg-tips").popover({
	    trigger:'hover',
	    placement:'top',
	    content:'打开时操作公有数据',
	    width :200,
	    
	});
	
	//登记号回车查询事件
	$("#dicKey").keydown(function (e) {
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
});

//查询字典数据
function Querydic(){
	$('#dg').datagrid('loadData',{total:0,rows:[]});
	// tangzf 2020-6-17 使用HISUI接口 加载数据
	var QueryParam={
		ClassName:'web.INSUDicDataCom' ,
		QueryName: 'QueryDicByTypeOrCodeDesc',
		Type :$('#diccbx').combobox('getValue'), 
		dicKey :getValueById('dicKey'), 
		HospDr : $('#csconflg').switchbox('getValue') ? "" : PUBLIC_CONSTANT.SESSION.HOSPID
	}
	seldictype=$('#diccbx').combobox('getValue');
	loadDataGridStore('dg',QueryParam);
	
}
//特殊字符处理
function SplVCFormat(FStr)
{
	return  FStr.replace(/\^/g,"");
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
	/*$('#code').val($('#code').val().replace(/\^/g,""));
	$('#desc').val($('#desc').val().replace(/\^/g,""));
	$('#insucode').val($('#insucode').val().replace(/\^/g,""));
	$('#insudesc').val($('#insudesc').val().replace(/\^/g,""));
	$('#note').val($('#note').val().replace(/\^/g,""));
	$('#defUserFlag').val($('#defUserFlag').val().replace(/\^/g,""));
	$('#opIPFlag').val($('#opIPFlag').val().replace(/\^/g,""));
	$('#userFlag').val($('#userFlag').val().replace(/\^/g,""));
	$('#relUserFlag').val($('#relUserFlag').val().replace(/\^/g,""));
	$('#insucode').val($('#insucode').val().replace(/\^/g,""));
	$('#insudesc').val($('#insudesc').val().replace(/\^/g,""));
	$('#note').val($('#note').val().replace(/\^/g,""));
	*/
	$('#code').val(SplVCFormat($('#code').val()));
	$('#desc').val(SplVCFormat($('#desc').val()));
	$('#insucode').val(SplVCFormat($('#insucode').val()));
	$('#insudesc').val(SplVCFormat($('#insudesc').val()));
	$('#note').val(SplVCFormat($('#note').val()));
	$('#defUserFlag').val(SplVCFormat($('#defUserFlag').val()));
	$('#opIPFlag').val(SplVCFormat($('#opIPFlag').val()));
	$('#userFlag').val(SplVCFormat($('#userFlag').val()));
	$('#relUserFlag').val(SplVCFormat($('#relUserFlag').val()));
	$('#insucode').val(SplVCFormat($('#insucode').val()));
	$('#insudesc').val(SplVCFormat($('#insudesc').val()));
	$('#note').val(SplVCFormat($('#note').val()));
	
	//20190102 DingSH
	var tautFlag=$HUI.combobox('#autFlag').getValue();
	if (undefined==tautFlag)
	{
		$.messager.alert('提示',"请选择正确的授权标识",'info')
		return;
	}
	
	if ((""!=tautFlag)&&(seldictype!="SYS"))
	{
		$.messager.alert('提示',"非系统(SYS)节点下字典类型,不能选择授权标识",'info')
		return ;
	}
	
	
		
	if($('#code').val().indexOf("请输入")>=0 || $('#code').val()==""){$.messager.alert('提示','请输入信息后再保存!','info');return;}
	if($('#desc').val().indexOf("请输入")>=0 || $('#desc').val()==""){$.messager.alert('提示','名称不能为空!','info');return;}
	if((seldictype=="")||(seldictype=='undefined')){
		$.messager.alert('提示','请选择字典类别!','info');return;
	}
	
	var saveinfo=selRowid+"^"+seldictype+"^"+$('#code').val()+"^"+$('#desc').val()+"^"+$('#insucode').val()+"^"+$('#insudesc').val()+"^"+$('#note').val();
	saveinfo=saveinfo+"^"+$HUI.combobox('#autFlag').getValue()+"^"+$('#opIPFlag').val()+"^"+$('#defUserFlag').val()+"^"+$('#userFlag').val()+"^"+$('#relUserFlag').val()+"^^^";
	saveinfo=saveinfo.replace(/请输入信息/g,"")
	///alert(saveinfo)
	var savecode=tkMakeServerCall("web.INSUDicDataCom","Update","","",saveinfo)
	//alert(savecode)
	if(eval(savecode)>0){
		//$.messager.alert('提示','保存成功!');  
		$("#dg").datagrid('reload')
		$("#dg").datagrid('unselectAll')
		clearform("")
		$.messager.alert('提示','保存成功!','info');   
	}else{
		if(eval(savecode)==-1001){
			$.messager.alert('提示','【'+$('#code').val()+'】此代码已存在相同记录!如果要更新内容请先查询出此代码的记录!','info');  
			return; 
		}
		$.messager.alert('提示','保存失败!','info');   
	}
}
//删除记录
function DelDic(){
	//if(BDPAutDisableFlag('btnDelete')!=true){$.messager.alert('提示','您无权限,请联系管理员授权!');return;}
	if(selRowid=="" || selRowid<0 || !selRowid){$.messager.alert('提示','请选择要删除的记录!','info');return;}
	$.messager.confirm('请确认','你确认要删除这条记录吗?',function(fb){
		if(fb){
			var savecode=tkMakeServerCall("web.INSUDicDataCom","Delete","","",selRowid)
			if(eval(savecode)>0){
				$.messager.alert('提示','删除成功!','info');   
				$("#dg").datagrid('reload')
				selRowid="";
				$("#dg").datagrid("getPager").pagination('refresh');
				$("#dg").datagrid('unselectAll')
			}else{
				$.messager.alert('提示','删除失败!','info');   
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
//填充下边的form
function fillform(rowIndex,rowData){
	// cType,cCode,cDesc,cDemo,cBill1,cBill2,selected:%Boolean,DicAuthorityFlag,DicOPIPFlag,DicUseFlag,DicRelationFlag,DicBill3,DicBill4,DicBill5
	selRowid=rowData.id
	//disinput(true);
	$('#code').val(rowData.cCode);
	$('#insucode').val(rowData.cBill1);
	$('#desc').val(rowData.cDesc);
	$('#insudesc').val(rowData.cBill2);
	$('#note').val(rowData.cDemo);
	
	$HUI.combobox('#autFlag').setValue(rowData.DicAuthorityFlag);
	//alert(rowData.selected)
	$('#defUserFlag').val(rowData.selected==true?"Y":"N");
	$('#opIPFlag').val(rowData.DicOPIPFlag);
	$('#userFlag').val(rowData.DicUseFlag);
	$('#relUserFlag').val(rowData.DicRelationFlag);
}
//清除下边的form
function clearform(inArgs){
	
	$('#editinfo input').each(function(){        
		$(this).val(inArgs)
	})
	selRowid="";
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
	
	$('#autFlag').attr("disabled",tf);
	$('#defUserFlag').attr("disabled",tf);
	$('#opIPFlag').attr("disabled",tf);
	$('#userFlag').attr("disabled",tf);
	$('#relUserFlag').attr("disabled",tf);

}


function addClear4Combogrid(theId,onChangeFun)
{
 var theObj = $(theId);
  
 //根据当前值，确定是否显示清除图标
 var showIcon = function(){  
  var icon = theObj.combogrid('getIcon',0);
  if (theObj.combogrid('getValue')){
   icon.css('visibility','visible');
  } else {
   icon.css('visibility','hidden');
  }
 };
  
 theObj.combogrid({
  //添加清除图标
  icons:[{
   iconCls:'icon-clear',
   handler: function(e){
    theObj.combogrid('clear');
   }
  }],
   
  //值改变时，根据值，确定是否显示清除图标
  onChange:function(){
   if(onChangeFun)
   {
    onChangeFun();
   }
   showIcon();
  }
   
 }); 
  
 //初始化确认图标显示
 showIcon();
}

function onChangeFun(){
	
}
function authorizeClick() {
	var dgSelected=$('#dg').datagrid('getSelected');
	if(PUBLIC_CONSTANT.SESSION.HOSPID==''){
		$.messager.alert('提示','先选择院区','info');
	}
	if(dgSelected&&dgSelected.id!=""){
		var savecode=tkMakeServerCall("web.INSUDicDataCom","Authorize",dgSelected.id,PUBLIC_CONSTANT.SESSION.HOSPID);
		if(savecode>0){
			$.messager.alert('提示','授权成功','info',function(){
				Querydic($('#diccbx').combogrid('grid').datagrid('getSelected'),$('#diccbx').combogrid('grid').datagrid('getSelected'));	
			});		
		}else{
			$.messager.alert('提示','授权失败：'+savecode,'info');	
		}
	}else{
		$.messager.alert('提示','请选择要授权的数据','info');
	}
}
function selectHospCombHandle(){
	var PublicDataSwitchBox = $('#csconflg').switchbox('getValue');
	if( PublicDataSwitchBox ){
		var rtn = tkMakeServerCall("web.DHCBILLINSUCloudCommon","SetSessionData",""); 	
	}
	$('#editinfo').form('clear');
	$('#diccbx').combogrid('grid').datagrid('unselectAll');
	setValueById('diccbx','');
	seldictype='';
	selRowid = -1;
	
	//异步加载
	$.cm({
		ClassName:"web.INSUDicDataCom",
		QueryName:"QueryDicSys",
		CodeAndDesc:'',
		queryFlag:"",
		rows:1000
	},function(jsonData){		
		$('#diccbx').combogrid('grid').datagrid('loadData',jsonData.rows);
	});	
	
	//加载grid
	var selobj ={
			INDIDDicCode : '',
			INDIDDicDemo : null
	}
	Querydic(selobj,selobj);
	//授权标志
	var comboJson=$.cm({
	    ClassName:"web.INSUDicDataCom",
	    QueryName:"QueryDic",
	    Type:"InsuDicAuthorityFlag",
	    Code:""
	 },false)
	 
	 setTimeout(function(){
		$HUI.combobox("#autFlag").loadData(comboJson.rows); 
	},100)
}
$('.hisui-linkbutton').bind('click',function(){
	 switch (this.id){ 
	    case "btnUpdate" : // 保存
	    	if(PassWardFlag == "N"){
		    	$.messager.prompt("提示", "请输入密码", function (r) { // prompt 此处需要考虑为非阻塞的
					if (r) {
						PassWardFlag = tkMakeServerCall("web.INSUDicDataCom","CehckPassWard",r,"");
						if(PassWardFlag=='Y') UpdateDic(); 
						else{
							$.messager.alert('错误','密码错误','error');	
						}
					} else {
						return false;
					}
				})
	    	}else{
	    		UpdateDic(); 
	    	}
	    	break;
	    case "btnDelete" : //删除
	    	if(PassWardFlag == "N"){
		    	$.messager.prompt("提示", "请输入密码", function (r) { // prompt 此处需要考虑为非阻塞的
					if (r) {
						PassWardFlag = tkMakeServerCall("web.INSUDicDataCom","CehckPassWard",r,"");
						if(PassWardFlag=='Y') DelDic(); 
						else{
							$.messager.alert('错误','密码错误','error');	
						}
					} else {
						return false;
					}
				})
	    	}else{
	    		DelDic(); 
	    	}
	    	break;
	    case "btnClear" :
	    	clearform();
	    	break;	
	    default :
	    	break;
	    }
		
}) 

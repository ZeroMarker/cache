/// Creator: congyue
/// CreateDate: 2015-11-16
//  Descript: 不良事件工作流定义

var editRow="",wfgrantRow="",wflevelRow="",wftimeRow="",wfdicRow="",nodeArr=[],count = 0;//当前编辑行号
var url="dhcadv.repaction.csp";
var dataArrayNew = [{"value":"4","text":'全院'},{"value":"1","text":'安全组'}, {"value":"2","text":'科室'}, {"value":"3","text":'人员'},{"value":"5","text":'大科'}]; //hxy 2017-12-14
var dataArray = [{"value":"1","text":'安全组'}, {"value":"2","text":'科室'}, {"value":"3","text":'人员'}]; //
var Active = [{"value":"Y","text":'是'}, {"value":"N","text":'否'}];
var Levelrowid="";
var level=0,parentid="",Eventeditor={type: 'text'};
var LevelArr=[{"value":"1","text":'一级'}, {"value":"2","text":'二级'}, {"value":"3","text":'三级'}, {"value":"4","text":'四级'}];
var HospDr="";
$(function(){
    InitHosp("DHC_AdrEvtWorkFlow"); 	//初始化医院 多院区改造 cy 2021-04-09 工作流定义数据管控 权限等数据私有
    InitHospBtn();  //初始化医院关联主句按钮 多院区改造  工作流定义数据管控 cy 2021-04-09
    InitTree();
	InitEvtWorkFlow();
	InitEvtWFGrant();
	InitEvtWFLevel();
	// 2021-03-22 cy 时限维护
	InitEvtWFTime();
	// 2021-03-25 cy 表单面板元素维护
	InitEvtWFDic();
	InitDefault();
})
function InitTree(){
	//事件分类元素树的加载 
	$('#tree').tree({
		url: 'dhcapp.broker.csp'+"?ClassName=web.DHCADVEVTWORKFLOW&MethodName=jsonCheckWorkFlow&id="+"Root"+"&HospDr="+HospDr,  /// jsonCheckWorkFlow1  jsonCheckWorkFlowByType 默认传参 "Root"  加载根目录和一级事件分类数据
    	lines:true,
    	onClick: function(node){
	    	level=node.level;
			level++;
			parentid=node.id;
			var tab = $('#tabs').tabs('getTab',0);
			if(parentid=="Root"){
				$('#tabs').tabs('update', {tab: tab,options: {title: '工作流'} });
				$("#copy").show();
				/// 2021-07-09 cy 点击Root 根据tab签选择的不同初始化相应的医院信息
				var seltab = $('#tabs').tabs('getSelected');
				var seltabtitle = seltab.panel('options').tab[0].textContent; 
				if((seltabtitle=="工作流")||(seltabtitle=="工作流项目")){
			    	InitHosp("DHC_AdrEvtWorkFlow");
			    }
		    	if(seltabtitle=="权限"){
			    	InitHosp("DHC_AdrWorkFlowGrant");
			    }
			    if(seltabtitle=="事件等级"){
			    	InitHosp("DHC_AdrEvtWorkFlowLink");
			    }
			    if((seltabtitle=="时限")||(seltabtitle=="元素")){
			    	InitHosp("DHC_AdvGenericRelation");
			    }
				
			}else{
				$('#tabs').tabs('update', {tab: tab,options: {title: '工作流项目'} });
				$("#copy").hide();
			}
			Query();
		},
		onLoadSuccess: function(node, data){
				for (var i=0;i<nodeArr.length;i++){
					var node = $('#tree').tree('find', nodeArr[i]);
					if (node != null){
						$('#tree').tree('expand', node.target);
						count = count + 1;
					}
				}
				if (count == nodeArr.length+1){
					nodeArr=[];
				}
				if(parentid!="")
				{
					var node = $('#tree').tree('find', parentid);	//找到id为tree这个树的节点id为parentid的对象
					if(node!=null)
					{
						$('#tree').tree('select', node.target);			//设置选中该节点

					}
				}				
		}

			
	});
}
// 初始化医院 多院区改造 cy 2021-04-09 此页面涉及多个表 所以初始化医院的表名根据具体内容具体传递表名
function InitHosp(TableName){
	hospComp = GenHospComp(TableName); 
	var QueTreFlag=0;
	ConHospdr=hospComp.getValue();
	if(HospDr!=""){ 
		/// 切换表名后，初始化前后医院不一致，则进行医院id替换  GetDefHospIdByTableName此方法获取该表名下此医院的配置医院id
		runClassMethod("web.DHCADVCOMMON","GetDefHospIdByTableName",{"TableName":TableName,"HospID":HospDr},
		function(ret){
			ConHospdr=ret;
			if(ret!=HospDr){
				HospDr=ret;
			}
			hospComp.setValue(HospDr);
		},'text',false);
		
	}
	hospComp.options().onSelect = function(){///选中事件
		HospDr=hospComp.getValue(); //cy 2021-04-09
		if(HospDr==ConHospdr){
			Query();
		}
		if(HospDr!=ConHospdr){
			QueryTree();
			Query();
		}
		ConHospdr=hospComp.getValue();
	}
	HospDr=hospComp.getValue(); //cy 2021-04-09
}
//初始化医院关联主句按钮 多院区改造  工作流定义数据管控 cy 2021-04-09
function InitHospBtn(){
	$("#_HospBtn").bind('click',function(){
		if((parentid!="Root")){
			$.messager.alert("提示","请在工作流页签中选择一条工作流数据!"); 
			return false;
		}
		var rowData = $("#evtworkflowdg").datagrid('getSelected');
		if (!rowData){
			$.messager.alert("提示","请在工作流页签中选择一条工作流数据！")
			return false;
		}
		GenHospWin("DHC_AdrEvtWorkFlow",rowData.ID);
	})

}
// 查询树 cy 2021-04-13  
function QueryTree(){
	$('#tree').tree({
		url: 'dhcapp.broker.csp'+"?ClassName=web.DHCADVEVTWORKFLOW&MethodName=jsonCheckWorkFlow&id="+"Root"+"&HospDr="+HospDr,  /// jsonCheckWorkFlow1  jsonCheckWorkFlowByType 默认传参 "Root"  加载根目录和一级事件分类数据
	})
}
function InitDefault(){
	$('#tabs').tabs({    
	    onSelect:function(title){  
	    	Query();
	    	/// 2021-07-09 cy 根据tab签选择的不同初始化相应的医院信息
	    	if((title=="工作流")||(title=="工作流项目")){
		    	InitHosp("DHC_AdrEvtWorkFlow");
		    }
	    	if(title=="权限"){
		    	InitHosp("DHC_AdrWorkFlowGrant");
		    }
		    if(title=="事件等级"){
		    	InitHosp("DHC_AdrEvtWorkFlowLink");
		    }
		    if((title=="时限")||(title=="元素")){
		    	InitHosp("DHC_AdvGenericRelation");
		    }
	    	
	    } 
	}); 
	
	$("#evtworkflowdg").datagrid('loadData',{total:0,rows:[]});
}

///数据表格加载调用
function Query(){
	var dgurl="";
	if((parentid=="Root")||(parentid=="")){
		dgurl=url+"?action=QueryAdrEvtworkFlow";
		$('#insertwf').show();
		$('#insertwfi').hide();
		$('#evtworkflowdg').datagrid('hideColumn','pri');
		$('#evtworkflowdg').datagrid('showColumn','EventType');
		$('#evtworkflowdg').datagrid('showColumn','Active');
	}else{
		$('#insertwf').hide();
		$('#insertwfi').show();
		dgurl=url+"?action=QueryEventWorkFlowItm";
		$('#evtworkflowdg').datagrid('showColumn','pri');
		$('#evtworkflowdg').datagrid('hideColumn','EventType');
		$('#evtworkflowdg').datagrid('hideColumn','Active');
		
	}
	$('#evtworkflowdg').datagrid({   //子项的加载      wangxuejian 2018-08-21
		url:dgurl,	
		queryParams:{
			params:parentid,
			HospDr:HospDr
		}
	});	
	$('#evtwfgrantdg').datagrid({
		url:'dhcadv.repaction.csp?action=QueryEventWorkFlowGrant',	
		queryParams:{
			params:parentid,
			HospDr:HospDr
		}
	});
	$('#evtwfleveldg').datagrid({
		url:'dhcadv.repaction.csp?action=QueryEvtWorkFlowLink',	
		queryParams:{
			params:parentid,
			HospDr:HospDr
		}
	});
	// 2021-03-22 cy 时限维护
	$('#evtwftimedg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVEVTWORKFLOW&MethodName=QueryWFUniversal'+'&LinkDr='+parentid+'&Type=TIME&HospDr='+HospDr
	});
	// 2021-03-25 cy 表单面板元素维护
	$('#evtwfdicdg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVEVTWORKFLOW&MethodName=QueryWFUniversal'+'&LinkDr='+parentid+'&Type=FORMDIC&HospDr='+HospDr
	});
	
	if(parentid.indexOf("||")>=0){
		// 事件等级
		$HUI.linkbutton("#inseventwfl").enable();
		$HUI.linkbutton("#deleventwfl").enable();
		$HUI.linkbutton("#saveventwfl").enable();
		// 2021-03-22 cy 时限维护
		$HUI.linkbutton("#instime").enable();
		$HUI.linkbutton("#deltime").enable();
		$HUI.linkbutton("#savtime").enable();
		// 2021-03-25 cy 表单面板元素维护
		$HUI.linkbutton("#insdic").enable();
		$HUI.linkbutton("#deldic").enable();
		$HUI.linkbutton("#savdic").enable();
	}else{
		// 事件等级
		$("#inseventwfl").linkbutton('disable');
		$("#deleventwfl").linkbutton('disable');
		$("#saveventwfl").linkbutton('disable');
		// 2021-03-22 cy 时限维护
		$("#instime").linkbutton('disable');
		$("#deltime").linkbutton('disable');
		$("#savtime").linkbutton('disable');
		// 2021-03-25 cy 表单面板元素维护
		$("#insdic").linkbutton('disable');
		$("#deldic").linkbutton('disable');
		$("#savdic").linkbutton('disable');
	}
}
function InitEvtWorkFlow(){
	
	// 复制 事件类型
	$('#copyType').combobox({
		valueField:'val',
		textField:'text',
		url: '',
		required:true,
		onShowPanel:function(){ 
			$('#copyType').combobox('reload','dhcapp.broker.csp'+"?ClassName=web.DHCADVCOMMONPART&MethodName=QueryEventCommbox&HospDr="+HospDr)
		
		},
		onHidePanel : function() {
			// 下拉框输入值校验--输入仅做检索使用，下拉框必须选择具体的数据 2021-0-6-25 cy
			chkcomboxvalue(this);
		}
	}); 
	//是否可用标志
	var activeEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			data:Active,
			valueField: "value", 
			textField: "text",
			required:true,
			panelHeight:"auto"  //设置容器高度自动增长
			
		}
	}
	//类型
	Eventeditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "val", 
			textField: "text",
			url: 'dhcapp.broker.csp'+"?ClassName=web.DHCADVCOMMONPART&MethodName=QueryEventCommbox&HospDr="+HospDr,  ///默认传参 "Root"  加载根目录和一级事件分类数据
			required:true,
			mode:'remote',
			onSelect:function(option){
				///设置类型值
				var ed=$("#evtworkflowdg").datagrid('getEditor',{index:editRow,field:'EventType'});
				$(ed.target).combobox('setValue', option.text); 
				var ed=$("#evtworkflowdg").datagrid('getEditor',{index:editRow,field:'EventTypeDr'});
				$(ed.target).val(option.val); 
			},
			onHidePanel : function() {
				// 下拉框输入值校验--输入仅做检索使用，下拉框必须选择具体的数据 2021-0-6-25 cy
				chkcomboxtext(this);
			}
		}
	}
	// 定义columns
	var columns=[[
		{field:"Code",title:'代码',width:150,editor:texteditor},
		{field:'Desc',title:'描述',width:150,editor:texteditor},
		{field:"EventTypeDr",title:'类型ID',width:80,editor:'text',hidden:true},
		{field:"EventType",title:'类型',width:300,editor:Eventeditor,hidden:false},
		{field:'Active',title:'是否可用',width:80,formatter:formatLink,editor:activeEditor},
		{field:"Level",title:'层级',width:100,hidden:true},
		{field:'Levelrowid',title:'上一层级ID',width:100,hidden:false},
		{field:'pri',title:'优先级',width:100,
				formatter:function(value,rec,index){
					var a = '<a href="#" mce_href="#" style="width:20px;height:20px;display:inline-block;" class="img icon-up" onclick="upclick(\''+ index + '\')"></a> ';
					var b = '<a href="#" mce_href="#" style="width:20px;height:20px;display:inline-block;" class="img icon-down" onclick="downclick(\''+ index + '\')"></a> ';
					return a+b;  
                    }  
		,hidden:true},
		{field:'OrderNo',title:'顺序号',width:130,hidden:false},
		{field:"ID",title:'ID',width:60,align:'center',hidden:false}

	]];
	// 定义datagrid
	$('#evtworkflowdg').datagrid({
		title:'',/* 不良事件工作流定义 */
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
		nowrap:false,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if ((editRow != "")||(editRow == "0")) {
            	if(CheckEdit("evtworkflowdg",editRow)){
		        	$.messager.alert("提示","请填写必填项信息!"); 
					return false;	    
	            }
            	$("#evtworkflowdg").datagrid('endEdit', editRow); 
			}
			//添加工作流（父表元素）时，EventType--不良事件分类列需要必填，添加工作流项目（子表元素）时，EventType--不良事件分类列设置非必填
			var EventTypett=$('#evtworkflowdg').datagrid('getColumnOption','EventType'); //通过列名获得此列
			if((parentid!="Root")){
				EventTypett.editor={type:'text'}; //设置此列的编辑属性
			}else{
				EventTypett.editor=Eventeditor; //设置此列的编辑属性
			}	
            $("#evtworkflowdg").datagrid('beginEdit', rowIndex);
            editRow = rowIndex; 
        }
	});
	
	initScroll("#evtworkflowdg");//初始化显示横向滚动条
 
 	//按钮绑定事件
    $('#insertwf').bind('click',insertRow); 
    $('#insertwfi').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
}


// 插入新行
function insertRow()
{	
	if((parentid=="")){
		$.messager.alert("提示","请选择根目录或者具体的工作流!"); 
		return false;
	}
	//添加工作流（父表元素）时，EventType--不良事件分类列需要必填，添加工作流项目（子表元素）时，EventType--不良事件分类列设置非必填
	var EventTypett=$('#evtworkflowdg').datagrid('getColumnOption','EventType'); //通过列名获得此列
	if((parentid!="Root")){
		EventTypett.editor={type:'text'}; //设置此列的编辑属性
	}else{
		EventTypett.editor=Eventeditor; //设置此列的编辑属性
	}		
	
	if(editRow>="0"){
		if(CheckEdit("evtworkflowdg",editRow)){
        	$.messager.alert("提示","请填写必填项信息!"); 
			return false;	    
        }
		$("#evtworkflowdg").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	var rows = $("#evtworkflowdg").datagrid('getChanges');
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Code=="")||(rows[i].Desc=="")){
			$.messager.alert("提示","请填写必填项信息!"); 
			return false;
		}
	} 
	
	$("#evtworkflowdg").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		
		index: 0, // 行数从0开始计算
		
		row: {ID: '',Code:'',Desc: '',Level:level,Levelrowid: parentid,Active: 'Y'}
	});
	
	$("#evtworkflowdg").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
	// 多院区改造 cy 2021-04-13 根据医院重新加载工作流维护的类型下拉数据
	var EventTypeed=$("#evtworkflowdg").datagrid('getEditor',{index:editRow,field:'EventType'});
	var url='dhcapp.broker.csp'+"?ClassName=web.DHCADVCOMMONPART&MethodName=QueryEventCommbox&HospDr="+HospDr;
	$(EventTypeed.target).combobox('reload',url);  
}

// 删除选中行
function deleteRow()
{
	var rows = $("#evtworkflowdg").datagrid('getSelections'); //选中要删除的行
	var dgurl=""
	if(parentid=="Root"){
		dgurl=url+'?action=DelAdrEvtworkFlow';
	}else {
		dgurl=url+'?action=DelAdrEvtworkFlowItm';
	}
	if (rows.length > 0) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				$.post(dgurl,{"params":rows[0].ID}, function(data){
					if(data==0){
						$.messager.alert('提示','删除成功');	
					}else if(data==-1){
						$.messager.alert('提示','此数据存在使用信息，不可删除');	
					}else{
						$.messager.alert('提示','删除失败');
					}
					$('#evtworkflowdg').datagrid('reload'); //重新加载
					RefreshTree(parentid);
				});
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
		$("#evtworkflowdg").datagrid('endEdit', editRow);
	}

	var rows = $("#evtworkflowdg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Code=="")||(rows[i].Desc=="")){
			$.messager.alert("提示","有必填项未填写，请核实!"); 
			return false;
		}		
		if(parentid=="Root"){
			var tmp=rows[i].ID+"^"+rows[i].Code+"^"+rows[i].Desc+"^"+rows[i].EventTypeDr+"^"+rows[i].Active;
		}else {
			var tmp=rows[i].ID+"^"+parentid+"^"+rows[i].Code+"^"+rows[i].Desc+"^"+rows[i].Active+"^"+rows[i].Level+"^"+rows[i].Levelrowid;
		}
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("&&");
	var dgurl=""
	if(parentid=="Root"){
		dgurl=url+'?action=SaveAdrEvtworkFlow';
	}else {
		dgurl=url+'?action=SaveAdrEvtworkFlowItm';
	}
	//保存数据
	$.post(dgurl,{"params":rowstr,"HospDr":HospDr},function(data){
		
		if(data==0){
			$.messager.alert('提示','操作成功');
		}else if ((data == -1)||((data == -2))){
			$.messager.alert('提示','代码重复,请核实后再试','warning');
		}else {
			$.messager.alert('提示','操作失败','warning');
		}
		$('#evtworkflowdg').datagrid('reload'); //重新加载
		RefreshTree(parentid);
	});
}
/// 刷新树 获取选中节点的所有父节点ID
function RefreshTree(parentid){

	runClassMethod("web.DHCADVEVTWORKFLOW","GetItmLevCon",{"ItmID":parentid},function(jsonString){
		if(jsonString){
			nodeArr = jsonString.split("^");
			count = 0;
		}
	},'',false);
	$('#tree').tree('reload');
	return;
}

// 编辑格
var texteditor={
	type: 'validatebox',//设置编辑格式
	options: {
		required: true //设置编辑规则属性
	}
}

/// ================================================================================
/// =====================================工作流权限设置=============================
function InitEvtWFGrant()
{
	//设置其为可编辑
	var editPoint={
		type: 'combobox',     //设置编辑格式
		options: {
			valueField: "value",
			textField: "text",
			required:true,
			mode:'remote',  //必须设置这个属性 2017-08-01 cy 修改下拉框模糊检索
			url:'dhcadv.repaction.csp?action=QueryEventWorkFlowGrant',	
			onSelect:function(option){
				var ed=$("#evtwfgrantdg").datagrid('getEditor',{index:wfgrantRow,field:'PointID'});
				$(ed.target).val(option.value);  //设置科室ID
				var ed=$("#evtwfgrantdg").datagrid('getEditor',{index:wfgrantRow,field:'Pointer'});
				$(ed.target).combobox('setValue', option.text);  //设置科室Desc
			}
		}
	}

	// 定义columns
	var columns=[[
		{field:"HospDr",title:'医院id',width:90,align:'center',hidden:false},
		{field:"ItmDr",title:'ItmDr',width:90,align:'center',hidden:true},
		{field:"ParRefDr",title:'ParRefDr',width:90,align:'center',hidden:true},
		{field:'TypeID',title:'TypeID',width:90,editor:'text',hidden:true},
		{field:"Type",title:'类型',width:110,editor:texteditor,
			editor: {  //设置其为可编辑
				type: 'combobox',//设置编辑格式
				options: {
					data:dataArrayNew,
					valueField: "value", 
					textField: "text",
					panelHeight:"auto",  //设置容器高度自动增长
					required:true,
					onSelect:function(option){
						///设置类型值
						var ed=$("#evtwfgrantdg").datagrid('getEditor',{index:wfgrantRow,field:'TypeID'});
						$(ed.target).val(option.value);  //设置科室ID
						
						var ed=$("#evtwfgrantdg").datagrid('getEditor',{index:wfgrantRow,field:'PointID'});
						$(ed.target).val(" ");        //乔庆澳 2016/7/12
						
						var ed=$("#evtwfgrantdg").datagrid('getEditor',{index:wfgrantRow,field:'Type'});
						$(ed.target).combobox('setValue', option.text);  //设置科室Desc
						///设置级联指针
						var paramType=option.value+"^"+LgGroupID;  //类型^安全组
						var ed=$("#evtwfgrantdg").datagrid('getEditor',{index:wfgrantRow,field:'Pointer'});
						var url='dhcadv.repaction.csp?action=GetSSPPoint&params='+paramType+'&HospDr='+HospDr;
						$(ed.target).combobox('setValue',"");
						$(ed.target).combobox('reload',url);  //乔庆澳 2016/7/12
						
					} 
				}
			}
		},
		{field:'Pointer',title:'指向',width:300,editor:editPoint},
		{field:'PointID',title:'PointID',width:130,editor:'text',hidden:true},
		{field:"ID",title:'ID',width:90,align:'center',hidden:true}
	]];
	// 定义datagrid
	$('#evtwfgrantdg').datagrid({
		title:'',
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		//pageSize:40,        // 每页显示的记录条数
		//pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		//pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if ((wfgrantRow != "")||(wfgrantRow == "0")) {
	            if(CheckEdit("evtwfgrantdg",wfgrantRow)){
		        	$.messager.alert("提示","请填写必填项信息!"); 
					return false;	    
	            }
            	$("#evtwfgrantdg").datagrid('endEdit', wfgrantRow);
			}
            $("#evtwfgrantdg").datagrid('beginEdit', rowIndex); 
            wfgrantRow = rowIndex; 
            
			///设置级联指针 huaxiaoying 2018-01-26 st
			var paramType=rowData.TypeID+"^"+LgGroupID;  //类型^安全组
			var ed=$("#evtwfgrantdg").datagrid('getEditor',{index:wfgrantRow,field:'Pointer'});
			var url='dhcadv.repaction.csp?action=GetSSPPoint&params='+paramType+'&HospDr='+HospDr;
			$(ed.target).combobox('reload',url); //ed
        
        }
	});
	
	initScroll("#evtwfgrantdg");//初始化显示横向滚动条
	
	//按钮绑定事件
    $('#inseventwfg').bind('click',inseventwfgRow); 		//乔庆澳 2016/713
    $('#deleventwfg').bind('click',deleventwfgRow);
    $('#saveventwfg').bind('click',saveventwfgRow);
	
}

// 插入新行
function inseventwfgRow()
{
	if((parentid=="")||(parentid=="Root")){
		$.messager.alert("提示","请选择一条事件分类树节点!"); 
		return false;
	}
	if(wfgrantRow>="0"){
		if(CheckEdit("evtwfgrantdg",wfgrantRow)){
        	$.messager.alert("提示","请填写必填项信息!"); 
			return false;	    
        }
		$("#evtwfgrantdg").datagrid('endEdit', wfgrantRow);//结束编辑，传入之前编辑的行
	}
	//////////////////////////////////////////////////////////////乔庆澳 2016/7/13
	var rows = $("#evtwfgrantdg").datagrid('getChanges');
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].TypeID=="")||($.trim(rows[i].PointID)=="")){
			$.messager.alert("提示","有必填项未填写，请核实!"); 
			return false;
		}		
	} 
	////////////////////////////////////////////////////////////////
	
	$("#evtwfgrantdg").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {ID: '',TypeID:'',PointID: '',HospDr:HospDr}
	});
	$("#evtwfgrantdg").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	wfgrantRow=0;
}

// 删除选中行
function deleventwfgRow()
{
	var rows = $("#evtwfgrantdg").datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				$.post(url+'?action=DelAdrWorkFlowGrant',{"params":rows[0].ID}, function(data){
					if(data==0){
						$.messager.alert('提示','操作成功');
					}else {
						$.messager.alert('提示','操作失败','warning');
						//return;	//2017-03-17 保存失败，刷新字典表
					}
					$('#evtwfgrantdg').datagrid('reload'); //重新加载
				});
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

// 保存编辑行
function saveventwfgRow()
{
	if(wfgrantRow>="0"){
		$("#evtwfgrantdg").datagrid('endEdit', wfgrantRow);
	}

	var rows = $("#evtwfgrantdg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((parentid=="")||(parentid=="Root")){
			$.messager.alert("提示","请选择一条工作流定义树节点!"); 
			return false;
		}
		if((rows[i].TypeID=="")||($.trim(rows[i].PointID)=="")){
			$.messager.alert("提示","有必填项未填写，请核实!"); 
			return false;
		}
		if(parentid.indexOf("||")<0){
			var tmp=rows[i].ID+"^"+parentid+"^"+rows[i].TypeID+"^"+rows[i].PointID+"^"+1+"^"+rows[i].HospDr;
		}else {
			var tmp=rows[i].ID+"^"+parentid+"^"+rows[i].TypeID+"^"+rows[i].PointID+"^"+2+"^"+rows[i].HospDr;
		}
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("&&");
	//保存数据
	$.post('dhcadv.repaction.csp?action=SaveAdrWorkFlowGrant',{"params":rowstr},function(data){
		if(data==0){
			$.messager.alert('提示','操作成功');
		}else if ((data == -1)||((data == -2))){
			$.messager.alert('提示','同一类型指向重复,请核实后再试','warning');
			//return;	//2017-03-17 保存失败，刷新字典表
		}else {
			$.messager.alert('提示','操作失败','warning');
			//return;	//2017-03-17 保存失败，刷新字典表
		}
		$('#evtwfgrantdg').datagrid('reload'); //重新加载
	});
}

//var eventwfitmdg;
//上移
function upclick(index)
{
     var newrow=parseInt(index)-1 
	 var curr=$("#evtworkflowdg").datagrid('getData').rows[index];
	 var currowid=curr.ID;
	 var currordnum=curr.OrderNo;
	 var up =$("#evtworkflowdg").datagrid('getData').rows[newrow];
	 var uprowid=up.ID;
     var upordnum=up.OrderNo;

	 var input=currowid+"^"+upordnum+"^"+uprowid+"^"+currordnum ;
     SaveUp(input);
	 mysort(index, 'up', 'evtworkflowdg');
	
}
//下移
function downclick(index)
{

	 var newrow=parseInt(index)+1 ;
	 var curr=$("#evtworkflowdg").datagrid('getData').rows[index];
	 var currowid=curr.ID;
	 var currordnum=curr.OrderNo;
	 var down =$("#evtworkflowdg").datagrid('getData').rows[newrow];
	 var downrowid=down.ID;
     var downordnum=down.OrderNo;

	 var input=currowid+"^"+downordnum+"^"+downrowid+"^"+currordnum ;
     SaveUp(input);
	 mysort(index, 'down', 'evtworkflowdg');
}
function SaveUp(input)
{
	 $.post(url+'?action=UpdEventWorkFlowItmNum',{"input":input},function(data){
		 $('#evtworkflowdg').datagrid('reload'); //重新加载
	});
	 
}
function mysort(index, type, gridname) {

    if ("up" == type) {

        if (index != 0) {
			var nextrow=parseInt(index)-1 ;
			var lastrow=parseInt(index);
            var toup = $('#' + gridname).datagrid('getData').rows[lastrow];
            var todown = $('#' + gridname).datagrid('getData').rows[index - 1];
            $('#' + gridname).datagrid('getData').rows[lastrow] = todown;
            $('#' + gridname).datagrid('getData').rows[nextrow] = toup;
            $('#' + gridname).datagrid('refreshRow', lastrow);
            $('#' + gridname).datagrid('refreshRow', nextrow);
            $('#' + gridname).datagrid('selectRow', nextrow);
        }
    } else if ("down" == type) {
        var rows = $('#' + gridname).datagrid('getRows').length;
        if (index != rows - 1) {
		    var nextrow=parseInt(index)+1 ;
			var lastrow=parseInt(index);
            var todown = $('#' + gridname).datagrid('getData').rows[lastrow];
            var toup = $('#' + gridname).datagrid('getData').rows[nextrow];
            $('#' + gridname).datagrid('getData').rows[nextrow] = todown;              
            $('#' + gridname).datagrid('getData').rows[lastrow] = toup;
            $('#' + gridname).datagrid('refreshRow', lastrow);
            $('#' + gridname).datagrid('refreshRow', nextrow);
            $('#' + gridname).datagrid('selectRow', nextrow);
        }
    }
}
//检查编辑行是否编辑完全 2018-07-18 cy
function CheckEdit(id,index){
	var flag=0;
	var editors = $('#'+id).datagrid('getEditors', index); 
	for (i=0;i<editors.length;i++){
		if(((editors[i].type=="validatebox")&&(editors[i].target.val()==""))){  ///|| ((editors[i].type=="text")&&(editors[i].target.val()==""))||((editors[i].type=="combobox")&&(editors[i].target.combobox('getText')==""))
			flag=-1;
			return flag;	
		}
	}
	return flag; 
} 
//YN转换是否
function formatLink(value,row,index){
	if (value=='Y'){
		return '是';
	} else {
		return '否';
	}
}


/// ================================================================================
/// =====================================工作流事件分级设置=============================
function InitEvtWFLevel()
{
	//设置其为可编辑
	var editLevel={
		type: 'combobox',     //设置编辑格式
		options: {
			data:LevelArr,
			valueField: "value",
			textField: "text",
			required:true,
			onSelect:function(option){
				var ed=$("#evtwfleveldg").datagrid('getEditor',{index:wflevelRow,field:'LevelDr'});
				$(ed.target).val(option.value);  //设置科室ID
				var ed=$("#evtwfleveldg").datagrid('getEditor',{index:wflevelRow,field:'Level'});
				$(ed.target).combobox('setValue', option.text);  //设置科室Desc
			}
		}
	}
	
	// 定义columns
	var columns=[[
		{field:"HospDr",title:'医院id',width:90,align:'center',hidden:true},
		{field:"LinkDr",title:'LinkDr',width:100,align:'center',hidden:true},
		{field:'Level',title:'等级',width:100,editor:editLevel,hidden:false},
		{field:'LevelDr',title:'LevelDr',width:100,editor:'text',hidden:true},
		{field:"ID",title:'ID',width:100,align:'center',hidden:true}
	]];
	// 定义datagrid
	$('#evtwfleveldg').datagrid({
		title:'',
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
	    singleSelect:true,
		loadMsg: '正在加载信息...',
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if ((wflevelRow != "")||(wflevelRow == "0")) {
	            if(CheckEdit("evtwfleveldg",wflevelRow)){
		        	$.messager.alert("提示","请填写必填项信息!"); 
					return false;	    
	            }
            	$("#evtwfleveldg").datagrid('endEdit', wflevelRow);
			}
            $("#evtwfleveldg").datagrid('beginEdit', rowIndex); 
            wflevelRow = rowIndex; 
        
        }
	});
	
	initScroll("#evtwfleveldg");//初始化显示横向滚动条
	
	//按钮绑定事件
    $('#inseventwfl').bind('click',inseventwflRow); 		//乔庆澳 2016/713
    $('#deleventwfl').bind('click',deleventwflRow);
    $('#saveventwfl').bind('click',saveventwflRow);
	
}

// 插入新行
function inseventwflRow()
{
	if((parentid=="")||(parentid=="Root")){
		$.messager.alert("提示","请选择一条事件分类树节点!"); 
		return false;
	}
	if(wflevelRow>="0"){
		if(CheckEdit("evtwfleveldg",wflevelRow)){
        	$.messager.alert("提示","请填写必填项信息!"); 
			return false;	    
        }
		$("#evtwfleveldg").datagrid('endEdit', wflevelRow);//结束编辑，传入之前编辑的行
	}
	var rows = $("#evtwfleveldg").datagrid('getChanges');
	for(var i=0;i<rows.length;i++)
	{
		if($.trim(rows[i].LevelDr)==""){
			$.messager.alert("提示","有必填项未填写，请核实!"); 
			return false;
		}		
	} 
	
	$("#evtwfleveldg").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {ID: '',LinkDr:parentid,Level: '',HospDr:HospDr}
	});
	$("#evtwfleveldg").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	wflevelRow=0;
}

// 删除选中行
function deleventwflRow()
{
	var rows = $("#evtwfleveldg").datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				$.post(url+'?action=DelEvtWorkFlowLink',{"params":rows[0].ID}, function(data){
					if(data==0){
						$.messager.alert('提示','操作成功');
					}else {
						$.messager.alert('提示','操作失败','warning');
						//return;	//2017-03-17 保存失败，刷新字典表
					}
					$('#evtwfleveldg').datagrid('reload'); //重新加载
				});
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

// 保存编辑行
function saveventwflRow()
{
	if(wflevelRow>="0"){
		$("#evtwfleveldg").datagrid('endEdit', wflevelRow);
	}

	var rows = $("#evtwfleveldg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((parentid=="")||(parentid=="Root")){
			$.messager.alert("提示","请选择一条工作流定义树节点!"); 
			return false;
		}
		if($.trim(rows[i].LevelDr)==""){
			$.messager.alert("提示","有必填项未填写，请核实!"); 
			return false;
		}
		var tmp=rows[i].ID+"^"+parentid+"^"+rows[i].LevelDr+"^"+rows[i].HospDr;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("&&");
	//保存数据
	$.post('dhcadv.repaction.csp?action=SaveEvtWorkFlowLink',{"params":rowstr},function(data){
		if(data==0){
			$.messager.alert('提示','操作成功');
		}else if ((data == -1)||((data == -2))){
			$.messager.alert('提示','同一类型指向等级重复,请核实后再试','warning');
		}else {
			$.messager.alert('提示','操作失败','warning');
		}
		$('#evtwfleveldg').datagrid('reload'); //重新加载
	});
}


/// ================================================================================
/// =====================================工作流事件 时限维护设置=============================
function InitEvtWFTime()
{
	//设置其为可编辑
	var editTimeToLevel={
		type: 'combobox',     //设置编辑格式
		options: {
			data:LevelArr,
			valueField: "value",
			textField: "text",
			onSelect:function(option){
				var ed=$("#evtwftimedg").datagrid('getEditor',{index:wftimeRow,field:'Attribute'});
				$(ed.target).val(option.value);  
				var ed=$("#evtwftimedg").datagrid('getEditor',{index:wftimeRow,field:'Level'});
				$(ed.target).combobox('setValue', option.text); 
			}
		}
	}
	
	// 定义columns
	var columns=[[
		{field:"HospDr",title:'医院id',width:90,align:'center',hidden:true},
		{field:"LinkDr",title:'LinkDr',width:100,align:'center',hidden:true},
		{field:"Type",title:'关联项类型',width:100,align:'center',hidden:false},
		{field:"Data",title:'时限',width:100,align:'center',editor:texteditor,hidden:false},
		{field:'Level',title:'等级',width:100,editor:editTimeToLevel,hidden:false},
		{field:'Attribute',title:'LevelDr',width:100,editor:'text',hidden:true},
		{field:'Remark',title:'备注',width:100,editor:'text',hidden:false},
		{field:"ID",title:'ID',width:100,align:'center',hidden:true}
	]];
	// 定义datagrid
	$('#evtwftimedg').datagrid({
		title:'',
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
	    singleSelect:true,
		loadMsg: '正在加载信息...',
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if ((wftimeRow != "")||(wftimeRow == "0")) {
	            if(CheckEdit("evtwftimedg",wftimeRow)){
		        	$.messager.alert("提示","请填写必填项信息!"); 
					return false;	    
	            }
            	$("#evtwftimedg").datagrid('endEdit', wftimeRow);
			}
            $("#evtwftimedg").datagrid('beginEdit', rowIndex); 
            wftimeRow = rowIndex; 
        
        }
	});
	
	initScroll("#evtwftimedg");//初始化显示横向滚动条
	
	//按钮绑定事件
    $('#instime').bind('click',instimeRow); 		
    $('#deltime').bind('click',deltimeRow);
    $('#savtime').bind('click',savtimeRow);
	
}

// 插入新行
function instimeRow()
{
	if((parentid=="")||(parentid=="Root")){
		$.messager.alert("提示","请选择一条事件分类树节点!"); 
		return false;
	}
	if(wftimeRow>="0"){
		if(CheckEdit("evtwfleveldg",wftimeRow)){
        	$.messager.alert("提示","请填写必填项信息!"); 
			return false;	    
        }
		$("#evtwftimedg").datagrid('endEdit', wftimeRow);//结束编辑，传入之前编辑的行
	}
	var rows = $("#evtwftimedg").datagrid('getChanges');
	for(var i=0;i<rows.length;i++)
	{
		if($.trim(rows[i].Data)==""){
			$.messager.alert("提示","有必填项未填写，请核实!"); 
			return false;
		}		
	} 
	
	$("#evtwftimedg").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {ID: '',LinkDr:parentid,Data:'',Level: '',Remark:'',HospDr:HospDr}
	});
	$("#evtwftimedg").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	wftimeRow=0;
}

// 删除选中行
function deltimeRow()
{
	var rows = $("#evtwftimedg").datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCADVEVTWORKFLOW","DelWFUniversal",{'ID':rows[0].ID},
				function(data){
					if(data==0){
						$.messager.alert('提示','操作成功');
					}else {
						$.messager.alert('提示','操作失败','warning');
					}
					$('#evtwftimedg').datagrid('reload'); //重新加载
				},"text");
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

// 保存编辑行
function savtimeRow()
{
	if(wftimeRow>="0"){
		$("#evtwftimedg").datagrid('endEdit', wftimeRow);
	}

	var rows = $("#evtwftimedg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((parentid=="")||(parentid=="Root")){
			$.messager.alert("提示","请选择一条工作流定义树节点!"); 
			return false;
		}
		if($.trim(rows[i].Data)==""){
			$.messager.alert("提示","有必填项未填写，请核实!"); 
			return false;
		}
		var tmp=rows[i].ID+"^"+"TIME"+"^"+parentid+"^"+rows[i].Data+"^"+rows[i].Attribute+"^"+rows[i].Remark+"^"+rows[i].HospDr;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("&&");
	//保存数据
	runClassMethod("web.DHCADVEVTWORKFLOW","SaveWFUniversal",{'DataList':rowstr},
	function(data){
		if(data==0){
			$.messager.alert('提示','操作成功');
		}else if ((data == -1)||((data == -2))){
			$.messager.alert('提示','同一类型指向等级重复,请核实后再试','warning');
		}else {
			$.messager.alert('提示','操作失败','warning');
		}
		$('#evtwftimedg').datagrid('reload'); //重新加载
	},"text");
}

/// ================================================================================
/// =====================================工作流事件 表单面板元素维护设置=============================
function InitEvtWFDic()
{
	/// 元素Combobox
	var FormDicEditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:"dhcapp.broker.csp?ClassName=web.DHCADVEVTWORKFLOW&MethodName=jsonFormDic&WFIID="+parentid+"&DicType=panel",
			required:true,
			//panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				/// 元素描述
				var ed=$("#evtwfdicdg").datagrid('getEditor',{index:wfdicRow,field:'DicDesc'});
				$(ed.target).combobox('setValue', option.text);
				/// 元素代码
				var ed=$("#evtwfdicdg").datagrid('getEditor',{index:wfdicRow,field:'DicCode'});
				$(ed.target).val(option.code);
				/// 元素ID
				var ed=$("#evtwfdicdg").datagrid('getEditor',{index:wfdicRow,field:'DicID'});
				$(ed.target).val(option.value); 
			}
		}
	}
	// 定义columns
	var columns=[[
		{field:"HospDr",title:'医院id',width:90,align:'center',hidden:true},
		{field:"LinkDr",title:'LinkDr',width:100,align:'center',hidden:true},
		{field:"Type",title:'关联项类型',width:100,align:'center',hidden:true},
		{field:'DicID',title:'元素ID',width:120,editor:texteditor,hidden:true},
		{field:'DicCode',title:'元素代码',width:120,editor:texteditor},
		{field:'DicDesc',title:'元素描述',width:120,editor:FormDicEditor},
		{field:'Attribute',title:'属性',width:100,editor:'text',hidden:false},
		{field:'Remark',title:'备注',width:200,editor:'text',hidden:false},
		{field:"ID",title:'ID',width:100,align:'center',hidden:true}
	]];
	// 定义datagrid
	$('#evtwfdicdg').datagrid({
		title:'',
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
	    singleSelect:true,
		loadMsg: '正在加载信息...',
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if ((wfdicRow != "")||(wfdicRow == "0")) {
	            if(CheckEdit("evtwfdicdg",wfdicRow)){
		        	$.messager.alert("提示","请填写必填项信息!"); 
					return false;	    
	            }
            	$("#evtwfdicdg").datagrid('endEdit', wfdicRow);
			}
            $("#evtwfdicdg").datagrid('beginEdit', rowIndex); 
            wfdicRow = rowIndex; 
        
        },onBeginEdit:function(index, rowData){
            var DicDesced=$("#evtwfdicdg").datagrid('getEditor',{index:index,field:'DicDesc'});
			var unitUrl="dhcapp.broker.csp?ClassName=web.DHCADVEVTWORKFLOW&MethodName=jsonFormDic&WFIID="+parentid+"&DicType=panel";
			$(DicDesced.target).combobox('reload',unitUrl);
        }
	});
	
	initScroll("#evtwfdicdg");//初始化显示横向滚动条
	
	//按钮绑定事件
    $('#insdic').bind('click',insdicRow); 		
    $('#deldic').bind('click',deldicRow);
    $('#savdic').bind('click',savdicRow);
	
}

// 插入新行
function insdicRow()
{
	if((parentid=="")||(parentid=="Root")){
		$.messager.alert("提示","请选择一条事件分类树节点!"); 
		return false;
	}
	if(wfdicRow>="0"){
		if(CheckEdit("evtwfleveldg",wfdicRow)){
        	$.messager.alert("提示","请填写必填项信息!"); 
			return false;	    
        }
		$("#evtwfdicdg").datagrid('endEdit', wfdicRow);//结束编辑，传入之前编辑的行
	}
	var rows = $("#evtwfdicdg").datagrid('getChanges');
	for(var i=0;i<rows.length;i++)
	{
		if($.trim(rows[i].DicCode)==""){
			$.messager.alert("提示","有必填项未填写，请核实!"); 
			return false;
		}		
	}
	
	$("#evtwfdicdg").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {ID: '',LinkDr:parentid, DicID:'', DicCode:'', DicDesc:'',Attribute:'',Remark:'',HospDr:HospDr}
	});
	$("#evtwfdicdg").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	wfdicRow=0;
}

// 删除选中行
function deldicRow()
{
	var rows = $("#evtwfdicdg").datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCADVEVTWORKFLOW","DelWFUniversal",{'ID':rows[0].ID},
				function(data){
					if(data==0){
						$.messager.alert('提示','操作成功');
					}else {
						$.messager.alert('提示','操作失败','warning');
					}
					$('#evtwfdicdg').datagrid('reload'); //重新加载
				},"text");
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

// 保存编辑行
function savdicRow()
{
	if(wfdicRow>="0"){
		$("#evtwfdicdg").datagrid('endEdit', wfdicRow);
	}

	var rows = $("#evtwfdicdg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((parentid=="")||(parentid=="Root")){
			$.messager.alert("提示","请选择一条工作流定义树节点!"); 
			return false;
		}
		if($.trim(rows[i].DicCode)==""){
			$.messager.alert("提示","有必填项未填写，请核实!"); 
			return false;
		}
		var tmp=rows[i].ID+"^"+"FORMDIC"+"^"+parentid+"^"+rows[i].DicCode+"^"+rows[i].Attribute+"^"+rows[i].Remark+"^"+rows[i].HospDr;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("&&");
	//保存数据
	runClassMethod("web.DHCADVEVTWORKFLOW","SaveWFUniversal",{'DataList':rowstr},
	function(data){
		if(data==0){
			$.messager.alert('提示','操作成功');
		}else if ((data == -1)||((data == -2))){
			$.messager.alert('提示','同一类型指向元素重复,请核实后再试','warning');
		}else {
			$.messager.alert('提示','操作失败','warning');
		}
		$('#evtwfdicdg').datagrid('reload'); //重新加载
	},"text");
}










/// 工作流复制 2021-03-19 cy
function WorkFlowCopy(){
	var rowsData = $("#evtworkflowdg").datagrid('getSelected');
	if (rowsData == null) {
		$.messager.alert("提示","请选择工作流!");
		return;	
	}
	$("#copyCode").val("");
	$("#copyName").val("");
	$("#copyType").combobox('setValue',""); 
	$('#copydialog').dialog("open");

}
/// 工作流复制保存 2021-03-19 cy
function SaveWorkFlowCopy(){
	if($("#copyWorkFlow").form('validate')){
		var rowsData = $("#evtworkflowdg").datagrid('getSelected');
		runClassMethod("web.DHCADVEVTWORKFLOW","CopyEvtWorkFlow",{
		'CopyID':rowsData.ID,'Code':$("#copyCode").val(),'Desc':$("#copyName").val(),
		'TypeDr':$("#copyType").combobox('getValue'),'HospDr':HospDr},
		function(data){
			if(data==1){
				$.messager.alert("提示","代码重复")
				return;
			}
			if(data==2){
				$.messager.alert("提示","保存失败")
				return;
			}
			$.messager.alert("提示","保存成功")
			$('#copydialog').dialog("close");
			$('#evtworkflowdg').datagrid('reload'); //重新加载
			RefreshTree(parentid);
		},"text");
	}
	
}

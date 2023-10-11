/// 名称: 医用知识库 -规则管理管理系统
/// 描述: 包含增删改查功能
/// 编写者: 基础数据平台组-谷雪萍
/// 编写日期: 2018-05-15

var init = function(){
	var HISUI_SQLTableName_Left="MKB_KLMappingBase",HISUI_ClassTableName_Left="User.MKBKLMappingBase";
	var HISUI_SQLTableName="MKB_KLMappingDetail",HISUI_ClassTableName="User.MKBKLMappingDetail";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBKLMappingDetail&pClassMethod=DeleteData";
	var DELETE_CELL_ACTION_URL= "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBKLMappingDetail&pClassMethod=DeleteCellData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBKLMappingDetail&pClassMethod=SaveData";
	var SAVE_CELL_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBKLMappingDetail&pClassMethod=SaveCellData";
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBKLMappingDetail&pClassMethod=GetMyList";
	var QUERY_ACTION_URL_BYTERMID = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBKLMappingDetail&pClassMethod=GetInfoByTermId";
	var QUERY_ACTION_URL_BYTERMEXP = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBKLMappingDetail&pClassMethod=GetInfoByExp";
	var CopyToSpecLoc_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBKLMappingDetail&pClassMethod=CopyDetailToOther";
	
	var SAVE_DOC_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.MKB.MKBKLMappingDetail&pClassMethod=SaveUploadDoc&pEntityName=web.Entity.MKB.MKBDocManage";
	var PREVIEW_FILE_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.TKBKnoManage&pClassMethod=Webservice";
	
	var editIndex = undefined;  //正在编辑的行index
	var rowsvalue=undefined;   //正在编辑的行数据
	var editIndexvalue="";    //点保存后记录该行的index
	var base=""  //选中的base
	var searchConfigs=""  //配置检索项
	var unsearchConfigs=""  //未选的列
	
	//表达式控件所需代码
	var cbg=null;//诊断表达式combogrid
	var searchNameCondition=""; //诊断表达式检索条件
	var SelMRCICDRowid=""; //诊断查找下拉框的诊断id
	
	//alert(mappingBase+"^"+termBase+"^"+termRowId)
	//术语描述，新增的时候给术语赋值
	var termDesc=""
	if (termRowId!="")
	{
		termDesc=tkMakeServerCall('web.DHCBL.MKB.MKBKLMappingDetail','GetAddDataDesc',termRowId,termBase);
	}
	//alert(detailIdStr)
	//表达式描述，新增的时候给表达式赋值
	var detailDescStr=""
	if (detailIdStr!="")
	{
		//detailDescStr=tkMakeServerCall('web.DHCBL.MKB.MKBKnoExpression','GetDiagDesc',detailIdStr);
		detailDescStr=tkMakeServerCall('web.DHCBL.MKB.MKBKLMappingDetail','GetExpDesc',detailIdStr);
	}
	
	//如果是术语界面调用该界面，则左侧面板隐藏
	if(mappingBase!="")
	{
		//$('#layout').layout('collapse','west'); 
		$('#layout .layout-panel-west').css('display','none'); 
		$("#layout").layout("resize");
	}
   ///**************************************************左侧列表显示(开始)**************************************************************/
    var basecolumns =[[
        {field:'MKBKMBRowId',title:'RowId',width:100,hidden:true,sortable:true},
        {field:'MKBKMBCode',title:'代码',width:100,sortable:true,hidden:true},
        {field:'MKBKMBDesc',title:'标题',width:100,sortable:true},
        {field:'MKBKMBMappingRelation',title:'映射关系',width:100,sortable:true,hidden:true},
        {field:'MKBKMBKnowledge1',title:'知识点1',width:100,sortable:true,hidden:true},
        {field:'MKBKMBKnowledge2',title:'知识点2',width:100,sortable:true,hidden:true},
		{field:'Knowledge1Type',title:'知识点1格式',width:100,sortable:true,hidden:true},
        {field:'Knowledge2Type',title:'知识点2格式',width:100,sortable:true,hidden:true},
		{field:'Knowledge1Desc',title:'知识点1描述',width:100,sortable:true,hidden:true},
        {field:'Knowledge2Desc',title:'知识点2描述',width:100,sortable:true,hidden:true},
        {field:'MKBKMBNote',title:'备注',width:100,sortable:true,hidden:true},
		{field:'extendChild',title:'映射字段表child',width:100,sortable:true,hidden:true},
		{field:'extendTitle',title:'映射字段表描述',width:100,sortable:true,hidden:true},
        {field:'extendType',title:'映射字段表类型',width:100,sortable:true,hidden:true},
		{field:'extendConfig',title:'映射字段表配置项',width:100,sortable:true,hidden:true},
		{field:'K1Child',title:'知识点1的可编辑列',width:100,sortable:true,hidden:true},
		{field:'K2Child',title:'知识点2的可编辑列',width:100,sortable:true,hidden:true},
		{field:'MKBKMBSequence',title:'顺序',width:100,sortable:true,hidden:true,
        		sorter:function (a,b){  
						    if(a.length > b.length) return 1;
						        else if(a.length < b.length) return -1;
						        else if(a > b) return 1;
						        else return -1;
				}        
        }
    ]];
    var basegrid = $HUI.datagrid("#basegrid",{
	    url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.MKB.MKBKLMappingDetail",
            QueryName:"GetBaseList",
            rowid:mappingBase
        },
        width:'100%',
        height:'100%',
        //fit:true,  //当设置为 true 时，面板（panel）的尺寸就适应它的父容器。
        //autoRowHeight: true,
        columns: basecolumns,  //列信息
        pagination: true,   //pagination   boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:15,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
		displayMsg:"",  //显示信息	显示 {from} 到 {to} ,从 {total} 条记录
		showPageList:"", //是否显示翻页条上的下拉行列表
		showRefresh:false, //是否显示翻页条上的刷新按钮	true	
        singleSelect:true,
        remoteSort:false,
        sortName : 'MKBKMBSequence',
		sortOrder : 'asc', 
        idField:'MKBKMBRowId',
        //rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true,//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        scrollbarSize :0,
		ClassTableName:HISUI_ClassTableName_Left,
		SQLTableName:HISUI_SQLTableName_Left, 
        onClickRow:function(rowIndex,rowData){
			ClickBaseGrid(rowIndex,rowData)
			//保存历史和频次记录
			RefreshSearchData(HISUI_ClassTableName_Left,rowData.MKBKMBRowId,"A",rowData.MKBKMBDesc)
		},
        onRowContextMenu:function (e, rowIndex,row) { //右键时触发事件

        },
		onLoadSuccess:function(){
			if(mappingBase!="")   //如果传入的mappingBase不为空（属性内容模块映射）
			{
				basegrid.selectRow(0)
				var record = $("#basegrid").datagrid("getSelected"); 
				if (record)
				{
					ClickBaseGrid(0,record)
				}

			}
		}
        
    }); 

	//查询按钮
	/*$("#TextBase").searchbox({
        searcher:function(value,name){
            SearchMapBase();
        }
    })*/
	//类百度查询框
	$('#TextBase').searchcombobox({ 
		url:$URL+"?ClassName=web.DHCBL.BDP.BDPDataHistory&QueryName=GetDataForCmb1&ResultSetType=array&tablename="+HISUI_ClassTableName_Left
	});
	
	$('#TextBase').combobox('textbox').bind('keyup',function(e){ 
		if (e.keyCode==13){ 
			SearchMapBase() 
		}
    }); 

    $("#btnLeftSearch").click(function (e) { 
		SearchMapBase();
	})  
    //查询方法
    function SearchMapBase(){
        //var desc=$.trim($('#TextBase').searchbox('getValue'));
		var desc=$("#TextBase").combobox('getText')
        $('#basegrid').datagrid('load',  {
            ClassName:"web.DHCBL.MKB.MKBKLMappingDetail",
            QueryName:"GetBaseList",
            rowid:mappingBase,
            'desc': desc
        });
    }
	
	//重置按钮
	$("#btnLeftRefresh").click(function (e) { 
		ClearMapBase();	
	}) 
	
	//重置方法
	ClearMapBase=function()
	{
		//$("#TextBase").searchbox('setValue', '');
		$("#TextBase").combobox('setValue', '');
        $('#basegrid').datagrid('load',  {
            ClassName:"web.DHCBL.MKB.MKBKLMappingDetail",
            QueryName:"GetBaseList",
            rowid:mappingBase
        });
		$('#basegrid').datagrid('unselectAll');
		//清空中间知识点映射管理列表，变为图片，改变标题
		//$("#layoutcenter").panel('setTitle','知识库规则管理'); 
		if (document.getElementById('mygrid').style.display=="")   //如果是mygrid加载的状态
		{	
			$('#mygrid').datagrid('loadData', { total: 0, rows: [] }); 
			$('#mygrid').datagrid('unselectAll');
			document.getElementById('mygrid').style.display='none';  //隐藏mygrid
			$("#div-img").show();  //展示初始图片			
			$("#layoutcenter").panel('setTitle','知识库规则维护'); 
		}
		
		//$("#layoutcenter").html('<img src="../scripts/bdp/Framework/icons/mkb/noselect-warn.png" width="auto" height="auto" alt="没有数据奥，选条数据看看把" />');
	}
	
	//左侧列表的单击事件
	ClickBaseGrid=function(index,row)
	{
		//alert(document.getElementById('mygrid').style.display)
		base=row.MKBKMBRowId;
		editIndex = undefined;  //正在编辑的行index
		rowsvalue=undefined;   //正在编辑的行数据
		oldrowsvalue=undefined;  //上一个编辑的行数据
		preeditIndex="";     //上一个编辑的行index
		searchConfigs=""  //配置检索项
		unsearchConfigs=""  //未选的列
		$('#mygrid').datagrid('unselectAll');
		$('#configgrid').datagrid('unselectAll');
		//$('#knoExe').css('display','none'); 
		$("#mypropertylist").hide();
		
		InitMyGrid();
		$("#TextDesc").searchbox('setValue', '');
		document.getElementById('mygrid').style.display='';  //显示mygrid
		$("#div-img").hide();		 //初始图片消失
	}
   ///**************************************************左侧列表显示(结束)**************************************************************/

	///**************************************************中间列表显示（开始）**************************************************************/
	var editIndex = undefined;  //正在编辑的行index
	var rowsvalue=undefined;   //正在编辑的行数据
	var oldrowsvalue=undefined;  //上一个编辑的行数据
	var preeditIndex="";     //上一个编辑的行index
	var expressInfoArr=[]   //表达式控件信息
	var textareInfoArr=[]  //多行文本框信息
	var sourseInfoArr=[]  //引用信息串
	var urlArr=[]  //url信息
	var defaultData=[] //默认值——在知识点处单击右键维护规则的时候，新增时自动赋值。
	

	
	//var textarea=[];
	//datagrid列
	/*var columns =[[  
					{field:'MKBKMDRowNum',title:'RowId',width:80,sortable:true,hidden:true}
				]];*/
	var noEditChildK1=""  //知识点1级联控件的child 2018-06-20
	var noEditChildK2=""   //知识点2级联控件的child 2018-06-20
	
	var gridTitle=""   //中间table的标题

	//生成扩展列
	CreateColumns=function()
	{
		expressInfoArr=[]  //表达式控件信息
		textareInfoArr=[]  //多行文本框信息
		urlArr=[]  //url信息
		defaultData=[] //新增时的默认值
		var IntChild=""  //his版icd对照里国际码的child   2018-10-29
		var IntFlagChild="" //his版icd对照里标记的child  2018-10-29
		var HisCodeChild=""  //his版icd对照里ICD编码的child   2018-10-29
		
		var expTypeArr=[]  //表达式类型
		var expBaseArr=[]  //表达式来源-base
		
		//datagrid列
		var columns =[[  
						{field:'MKBKMDRowNum',title:'RowId',width:80,sortable:true,hidden:true}
					]];
					
		var record = $("#basegrid").datagrid("getSelected"); 
		if (!(record))
		{	
			return;
		}
		var base=record.MKBKMBRowId
		var MKBKMBDesc=record.MKBKMBDesc;  //标题
		var MKBKMBMappingRelation=record.MKBKMBMappingRelation;  //映射关系
		if (MKBKMBMappingRelation==1){
			MKBKMBMappingRelation="单向映射(1-2)"
		}
		else if (MKBKMBMappingRelation==2){
			MKBKMBMappingRelation="单向映射(2-1)"
		}
		else{
			MKBKMBMappingRelation="双向映射"
		}

		var MKBKMBKnowledge1 =record.MKBKMBKnowledge1
		var Knowledge1Desc =record.Knowledge1Desc
		var Knowledge1Type =record.Knowledge1Type
		
		var MKBKMBKnowledge2 =record.MKBKMBKnowledge2
		var Knowledge2Desc =record.Knowledge2Desc
		var Knowledge2Type =record.Knowledge2Type
		
		//上传文献按钮显示与否
		if ((MKBKMBKnowledge1=="D")||(MKBKMBKnowledge2=="D"))
		{
			$('#upload_btn').css('display',''); 
		}
		else
		{
			$('#upload_btn').css('display','none'); 
		}
		
		var MKBKMBNote=record.MKBKMBNote;  //备注
		
		//设置属性维护标题
		var notetip=MKBKMBNote
		if (notetip.length>20){
			notetip=notetip.substr(0,18)+"..."
		}		
		gridTitle='<span class="titleCls">标题：</span>'+MKBKMBDesc+"&nbsp;&nbsp;/&nbsp;&nbsp;"+'<span class="titleCls">知识点1：</span>'+Knowledge1Desc+"&nbsp;&nbsp;/&nbsp;&nbsp;"+'<span class="titleCls">知识点2：</span>'+Knowledge2Desc+"&nbsp;&nbsp;/&nbsp;&nbsp;"
				+'<span class="titleCls">映射关系：</span>'+MKBKMBMappingRelation+"&nbsp;&nbsp;/&nbsp;&nbsp;"+'<span class="titleCls" >备注：</span><span class="mytooltip" title="'+MKBKMBNote+'">'+notetip+'</span>'
				
		$('#layoutcenter').panel('setTitle',gridTitle)
		$('.mytooltip').tooltip();
		
		var extendChild =record.extendChild;  //扩展属性child串
		var extendTitle =record.extendTitle;  //扩展属性名串
		var extendType =record.extendType;    //扩展属性格式串
		var extendConfig =record.extendConfig;    //扩展属性配置项串
		var K1Child=record.K1Child
		var K2Child=record.K2Child

		 //如果有扩展属性，则自动生成列
		if (extendChild!="")  
		{
			noEditChildK1=""
			noEditChildK2=""
			var colsField = extendChild.split("[N]"); 
			var colsHead = extendTitle.split("[N]"); 
			var typeStr = extendType.split("[N]"); 
			var configStr = extendConfig.split("[N]"); 
			for (var i = 0; i <colsField.length; i++) {
				var fieldid=colsField[i]; 
				var labelName=colsHead[i];  //标题
				var comId='Extend'+colsField[i];   //控件id				
				var type=typeStr[i]   //类型
				var configInfos=configStr[i]  //配置项
	
				//添加列 方法2
				var column={};  
				column["title"]=labelName;  
				column["field"]=comId;  
				column["width"]=150;  
				column["sortable"]=false; 
				if (type=="TX") //文本框
				{
					column["editor"]='validatebox'
					if ((labelName=="国际码")&(MKBKMBDesc=="HIS版ICD对照"))   //his版icd对照里的国际码，放在上面时鼠标悬浮提示中文释义 2018-10-29
					{
						IntChild=fieldid
						column["formatter"]=function(value,row,index){  
							//鼠标悬浮显示中文释义
							var showValue=value
							if (value!="")
							{
								var IntDesc=""
								//var IntDesc=tkMakeServerCall('web.DHCBL.MKB.MKBKLMappingDetail','GetTooltipByIntCode',value);
								if (IntDesc!="")
								{
									showValue='<span class="mytooltip" title="'+IntDesc+'">'+value+'</span>'
								}
							}
							
							return showValue
						}					
					}
				}
				else if (type=="TA")  //多行文本框
				{
					column["editor"]={type:'textarea'}
					column["formatter"]=function(value,row,index){  
						//鼠标悬浮显示备注信息
						return '<span class="mytooltip" title="'+value+'">'+value+'</span>'
					}
					
					//多行文本框
					textareInfoArr[fieldid]=""
				}
				else if((type=="K1")||(type=="K2")||(type=="TP"))  //知识点1和知识点2
				{	
					//如果是知识点1或者知识点2的 不可编辑列
					if(((type=="K1")&(configInfos!="Exp")&(K1Child!=fieldid)&(K1Child!=""))||((type=="K2")&(configInfos!="Exp")&(K2Child!=fieldid)&(K2Child!="")))
					{
						if ((labelName=="ICD编码")&(MKBKMBDesc=="HIS版ICD对照"))   //his版icd的编码  2018-10-29
						{
							HisCodeChild=fieldid
						}
						column["editor"]='validatebox'
						if (type=="K1")
						{
							if(noEditChildK1!="") {noEditChildK1=noEditChildK1+","+fieldid}
							else {noEditChildK1=fieldid}
						}
						if  (type=="K2")
						{
							if(noEditChildK2!="") {noEditChildK2=noEditChildK2+","+fieldid}
							else {noEditChildK2=fieldid}
							
						}
						
					}
					else
					{				
						//column["editor"]='validatebox'
						if (configInfos=="") return 
						
						//存放id
						//先加一列
						var columnF={};
						columnF["title"]=labelName+"ID";  
						columnF["field"]=comId+"F";  
						columnF["editor"]='validatebox';
						columnF["width"]=150;  
						columnF["sortable"]=false;
						columnF["hidden"]=true;
						columns[0].push(columnF)
						
						var klType="",klBase=""
						if (type=="K1"){
							klType=Knowledge1Type
							klBase=MKBKMBKnowledge1
						}else{
							klType=Knowledge2Type
							klBase=MKBKMBKnowledge2
						}
																
						if ((((type=="K1")||(type=="K2"))&(configInfos=="Desc"))||(type=="TP"))   //中心词
						{
							sourseInfoArr[fieldid]=""

							if (type=="TP") //引用术语格式
							{
								expBaseArr[fieldid]=configInfos.split("&")[0]
								expTypeArr[fieldid]=configInfos.split("&")[1]
							}
							else //知识点
							{
								expBaseArr[fieldid]=klBase
								expTypeArr[fieldid]=klType
								
								//如果映射配置项=知识点1或知识点2
								if ((expBaseArr[fieldid]==termBase)&(termBase!=""))
								{
									
									if (expTypeArr[fieldid]=="T")
									{
										defaultData[fieldid]="T"
									}
									else
									{
										defaultData[fieldid]="L"
									}
								}
							}

							
							if (expBaseArr[fieldid]=="D") //文献管理
							{
									urlArr[fieldid]=$URL+"?ClassName=web.DHCBL.MKB.MKBKLMappingDetail&QueryName=GetDocManageCmb&ResultSetType=array"									
									column["editor"]={
										type:'combobox',
										options:{
											//url:$URL+"?ClassName=web.DHCBL.MKB.MKBKLMappingDetail&QueryName=GetDocManageCmb&ResultSetType=array",
											valueField:'MKBDMRowId',
											textField:'MKBDMDesc',
											//delay:500,
											//mode:'remote',
											comboFieldId:fieldid, //child
											onShowPanel:function(){
												var opts = $(this).combobox('options')
								         		if (opts)
								         		{
								         			$(this).combobox('reload',urlArr[opts.comboFieldId]);
								         		}
								         	},
								         	onHidePanel:function(){
								         		//改变id 列的值
								         		var opts = $(this).combobox('options')
								         		if (opts)
								         		{
													var val=$(this).combobox('getText');
													var ed=$("#mygrid").datagrid("getEditor",{index:editIndex,field:"Extend"+opts.comboFieldId+"F"});							
													$(ed.target).val(val)
								         		}
											}
										}
									}
							}
							else if(expBaseArr[fieldid]=="A") //评估表
							{
									urlArr[fieldid]=$URL+"?ClassName=web.DHCBL.MKB.MKBKLMappingDetail&QueryName=GetAssBaseCmb&ResultSetType=array"
									
									column["editor"]={
										type:'combobox',
										options:{
											//url:$URL+"?ClassName=web.DHCBL.MKB.MKBKLMappingDetail&QueryName=GetAssBaseCmb&ResultSetType=array",
											valueField:'MKBABRowId',
											textField:'MKBABDesc',
											//delay:500,
											//mode:'remote',
											comboFieldId:fieldid, //child
											onShowPanel:function(){		
												var opts = $(this).combobox('options')
								         		if (opts)
								         		{
								         			$(this).combobox('reload',urlArr[opts.comboFieldId]);
								         		}

								         	},
								         	onHidePanel:function(){
								         		//改变id 列的值
								         		var opts = $(this).combobox('options')
								         		if (opts)
								         		{
													var val=$(this).combobox('getText');
													var ed=$("#mygrid").datagrid("getEditor",{index:editIndex,field:"Extend"+opts.comboFieldId+"F"});							
													$(ed.target).val(val)
								         		}

											}
										}
									}			
							}
							else  //注册出来的术语
							{

								if (expTypeArr[fieldid]=="T")  //下拉树			
								{	
									urlArr["T"+fieldid]="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetJsonDataForTermCmb&base="+expBaseArr[fieldid]
									
									column["editor"]={
										type:'combotree',
										options:{
											//url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetJsonDataForCmb&base="+expBaseArr[fieldid],
											comboFieldId:fieldid, //child
											comboType:type,   //K1还是K2
											onBeforeExpand:function(node){
												$(this).tree('expandFirstChildNodes',node)
									        },
											onShowPanel:function(){		
												var opts = $(this).combotree('options')
								         		if (opts)
								         		{
								         			$(this).combotree('reload',urlArr["T"+opts.comboFieldId]);
								         		}

								         	},
											onHidePanel:function(){
												if($(this).combo('getText')==""){
													$(this).combo('setValue',"")
												}
								         		//改变id 列的值
								         		var opts = $(this).combotree('options')
								         		if (opts)
								         		{
								         			var target=$(this)
													setTimeout(function(){
														//var val=target.next().find('.combo-text').val();
														var val=target.combobox('getText');
														var ed=$("#mygrid").datagrid("getEditor",{index:editIndex,field:"Extend"+opts.comboFieldId+"F"});							
														$(ed.target).val(val)
														
														var termid=target.combobox('getValue');
														if ((opts.comboType=="K1")&(noEditChildK1!="")&(termid!=""))
														{
															var q1Str = noEditChildK1.split(","); 
															for (var q1 = 0; q1 <q1Str.length; q1++) {
																var ed=$("#mygrid").datagrid("getEditor",{index:editIndex,field:"Extend"+q1Str[q1]});
																var termdata=tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingDetail","GetNoEditDetailValue",base,q1Str[q1],termid,K1Child,K2Child)
																termdata=termdata.replace(/<br\/>/g,"");    //处理多行文本的情况
																$(ed.target).val(termdata)
															}
														}
														if ((opts.comboType=="K2")&(noEditChildK2!="")&(termid!=""))
														{
															var q2Str = noEditChildK2.split(","); 
															for (var q2 = 0; q2 <q2Str.length; q2++) {
																var ed=$("#mygrid").datagrid("getEditor",{index:editIndex,field:"Extend"+q2Str[q2]});
																var termdata=tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingDetail","GetNoEditDetailValue",base,q2Str[q2],termid,K1Child,K2Child)
																termdata=termdata.replace(/<br\/>/g,"");    //处理多行文本的情况
																$(ed.target).val(termdata)		
															}
														}
														
													},100)

								         		}
											}										
										}
									}
									
								}
								else   //下拉框
								{
									urlArr[fieldid]=$URL+"?ClassName=web.DHCBL.MKB.MKBTermProDetail&QueryName=GetTermCmb&ResultSetType=array&base="+expBaseArr[fieldid]
									//alert(expBaseArr[fieldid])
									column["editor"]={
										type:'combobox',
										options:{
											//url:$URL+"?ClassName=web.DHCBL.MKB.MKBTermProDetail&QueryName=GetTermCmb&ResultSetType=array&base="+expBaseArr[fieldid],
											valueField:'MKBTRowId',
											textField:'MKBTDesc',
											comboFieldId:fieldid, //child
											comboType:type,   //K1还是K2
											delay:500,
											mode:'remote',
											/*onLoadSuccess:function(){
												var termid=$.trim($(this).combobox('getValue'));
												var termdata=tkMakeServerCall("web.DHCBL.MKB.MKBTerm","GetDesc",termid)
												$(this).combobox('setText', termdata);
											},*/
											/*keyHandler:{
								        		query:function(){
										            var desc=$.trim($(this).combobox('getText'));
									                $(this).combobox('reload',myurl+"&q="+encodeURI(desc));
									                $(this).combobox("setValue",desc);
								             	}  
								         	},*/
								         	onShowPanel:function(){							         		
								         		var opts = $(this).combobox('options')
								         		if (opts)
								         		{
								         			$(this).combobox('setValue',"");
								         			$(this).combobox('reload',urlArr[opts.comboFieldId]);
								         		}
								         	},
											onHidePanel:function(){
												//设置知识点级联 2018-06-20
												/*var ed=$("#mygrid").datagrid("getEditor",{index:editIndex,field:"Extend6"});
												//$(ed.target).combobox('setText',"text");
												$(ed.target).val("aa")*/
												var opts = $(this).combobox('options')
												var termid=$(this).combobox('getValue');
												if ((opts.comboType=="K1")&(noEditChildK1!="")&(termid!=""))
												{
													var q1Str = noEditChildK1.split(","); 
													for (var q1 = 0; q1 <q1Str.length; q1++) {
														var ed=$("#mygrid").datagrid("getEditor",{index:editIndex,field:"Extend"+q1Str[q1]});
														var termdata=tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingDetail","GetNoEditDetailValue",base,q1Str[q1],termid,K1Child,K2Child)
														termdata=termdata.replace(/<br\/>/g,"");    //处理多行文本的情况
														$(ed.target).val(termdata)
													}
												}
												if ((opts.comboType=="K2")&(noEditChildK2!="")&(termid!=""))
												{
													var q2Str = noEditChildK2.split(","); 
													for (var q2 = 0; q2 <q2Str.length; q2++) {
														var ed=$("#mygrid").datagrid("getEditor",{index:editIndex,field:"Extend"+q2Str[q2]});
														var termdata=tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingDetail","GetNoEditDetailValue",base,q2Str[q2],termid,K1Child,K2Child)
														termdata=termdata.replace(/<br\/>/g,"");    //处理多行文本的情况
														$(ed.target).val(termdata)
														
														//给国际码赋值   2018-10-29
														if ((HisCodeChild!="")&&(HisCodeChild==q2Str[q2])&&(IntChild!="")&&(termdata!=""))
														{
															//获取到国际码的单元格
															var intcode=termdata.substring(0,5)
															var inted=$("#mygrid").datagrid("getEditor",{index:editIndex,field:"Extend"+IntChild});
															$(inted.target).val(intcode)    //国际码赋值
															if ((IntFlagChild!="")&&(intcode!="")&&(termid!="")){  //给标识赋值
																var flagdata=tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingDetail","GetFlagByIntCode",intcode,termid)
																var flaged=$("#mygrid").datagrid("getEditor",{index:editIndex,field:"Extend"+IntFlagChild});
																$(flaged.target).combobox('setValue',flagdata);
																
															}
														}
														
													}
												}
												
											
												//改变id 列的值
												var val=$(this).combobox('getText');
												var edF=$("#mygrid").datagrid("getEditor",{index:editIndex,field:"Extend"+opts.comboFieldId+"F"});
												if (edF)
												{
													$(edF.target).val(val)	
												}
												/*if ($(this).combo!=undefined){
													$(this).combobox('hidePanel'); 
												}*/

												/*$('#mygrid').datagrid('getRows')[editIndex]['Extend6'] = "text";
												$('#mygrid').datagrid('refreshRow', editIndex);
												$('#mygrid').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);	*/
												
											}
											
										}
									}
								}
							}
						}
						else if(configInfos=="Exp")  //表达式
						{
							//column["editor"]='validatebox'
							column["editor"]=DisplayNameEditor  //表达式控件所需代码
							
							expressInfoArr[fieldid]=klBase
							
							//如果映射配置项=知识点1或知识点2
							if ((expressInfoArr[fieldid]==termBase)&(termBase!=""))
							{								
								defaultData[fieldid]="Exp"
							}

						}
						else  //属性的id
						{
							sourseInfoArr[fieldid]=""
							//如果映射配置项=知识点1或知识点2
							if ((klBase==termBase)&(termBase!=""))
							{								
								defaultData[fieldid]="L"
							}
							urlArr[fieldid]=$URL+"?ClassName=web.DHCBL.MKB.MKBKLMappingDetail&QueryName=GetDataForDetailCmb&ResultSetType=array&basePro="+configInfos

							column["editor"]={
								type:'combobox',
								options:{
									//url:$URL+"?ClassName=web.DHCBL.MKB.MKBKLMappingDetail&QueryName=GetDataForDetailCmb&ResultSetType=array&basePro="+configInfos,
									valueField:'termId',
									textField:'MKBTPDDesc',
									baseProId:configInfos,
									comboFieldId:fieldid, //child
									comboType:type,   //K1还是K2
									delay:500,
									mode:'remote',
									onShowPanel:function(){
							         	var opts = $(this).combobox('options')
						         		if (opts)
						         		{
						         			$(this).combobox('setValue',"");
						         			$(this).combobox('reload',urlArr[opts.comboFieldId]);
						         		}
						         	},
									onLoadSuccess:function(){
										/*var termid=$.trim($(this).combobox('getValue'));
										var opts = $(this).combobox('options'); 										
										var termdata=tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingDetail","GetProDetailDesc",opts.baseProId,termid)
										termdata=termdata.replace(/<br\/>/g,"");   //处理多行文本的情况
										$(this).combobox('setText', termdata);*/
										var termdata=$.trim($(this).combobox('getText'));
										termdata=termdata.replace(/<br\/>/g,"");   //处理多行文本的情况
										$(this).combobox('setText', termdata);
										
									},
									onHidePanel:function(){
										//设置知识点级联 2018-06-20
										var opts = $(this).combobox('options')
										var termid=$(this).combobox('getValue');
										if ((opts.comboType=="K1")&(noEditChildK1!="")&(termid!=""))
										{
											var q1Str = noEditChildK1.split(","); 
											for (var q1 = 0; q1 <q1Str.length; q1++) {
												var ed=$("#mygrid").datagrid("getEditor",{index:editIndex,field:"Extend"+q1Str[q1]});
												var termdata=tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingDetail","GetNoEditDetailValue",base,q1Str[q1],termid,K1Child,K2Child)
												termdata=termdata.replace(/<br\/>/g,"");    //处理多行文本的情况
												$(ed.target).val(termdata)
											}
										}
										if ((opts.comboType=="K2")&(noEditChildK2!="")&(termid!=""))
										{
											var q2Str = noEditChildK2.split(","); 
											for (var q2 = 0; q2 <q2Str.length; q2++) {
												var ed=$("#mygrid").datagrid("getEditor",{index:editIndex,field:"Extend"+q2Str[q2]});
												var termdata=tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingDetail","GetNoEditDetailValue",base,q2Str[q2],termid,K1Child,K2Child)
												termdata=termdata.replace(/<br\/>/g,"");   //处理多行文本的情况
												$(ed.target).val(termdata)		
											}
										}
										
										//选择后赋值 -处理多行文本的情况
										var text=$(this).combobox('getText');
										text=text.replace(/<br\/>/g,"");   
										$(this).combobox('setText',text);
										
										//改变id 列的值
										var val=$(this).combobox('getText');
										var ed=$("#mygrid").datagrid("getEditor",{index:editIndex,field:"Extend"+opts.comboFieldId+"F"});
										if (ed)
									    {
											$(ed.target).val(val)	
										}
										
									}
								}
							}
						}
					}
				
				}			
				else if (type=="C")  //下拉框
				{	
			
					var configs = configInfos.split("&%"); 
					var storeData=new Array()
					for (var j = 0; j <configs.length; j++) {
						var data={};  
						data["value"]=configs[j];  
						data["text"]=configs[j];  
						storeData.push(data)	
					}
					column["editor"]={
						type:'combobox',
						options:{
							valueField:'value',
							textField:'text',
							data:storeData						
						}
					}	
					
				}
				else if (type=="R")  //单选框
				{
					if ((labelName=="标记")&(MKBKMBDesc=="HIS版ICD对照"))   //his版icd对照里的标记  2018-10-29
					{
						IntFlagChild=fieldid
					}
					var configs = configInfos.split("&%"); 
					var storeData=new Array()
					for (var j = 0; j <configs.length; j++) {
						var data={};  
						data["value"]=configs[j];  
						data["text"]=configs[j];  
						storeData.push(data)	
					}
					column["editor"]={
						type:'comboboxradio',					
						options:{
							valueField:'value',
							textField:'text',
							data:storeData,
							comId:comId						
						}
					}	
					
				}
				else if (type=="CB")
				{
					var configs = configInfos.split("&%"); 
					var storeData=new Array()
					for (var j = 0; j <configs.length; j++) {
						var data={};  
						data["value"]=configs[j];  
						data["text"]=configs[j];  
						storeData.push(data)	
					}
					column["editor"]={
						type:'combobox',
						options:{
							rowStyle:'checkbox', //显示成勾选行形式
							valueField:'value',
							textField:'text',
							data:storeData,
							comId:comId,
							multiple:true
						}
					}					
				}
				columns[0].push(column)
			
			}
		}
		return columns
	}
	
	var copyfieldname = ""  //复制列Extend+child
	var copyfieldval=""    //复制列的实际值
	var copyfieldtext=""    //复制列的展示值
	var copyfieldbase=""    //复制列表达式的来源-base（术语库注册id）
	var pastefieldname=""   //粘贴列Extend+child
	var pastefieldval=""    //粘贴列值
	var pastefieldbase=""    //粘贴列表达式的来源-base（术语库注册id）
	
	//中间可编辑列表datagrid定义
	var mygrid = $HUI.datagrid("#mygrid",{
		//url:QUERY_ACTION_URL+"&base="+base,
		//columns:columns,
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:100,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		idField:'MKBKMDRowNum', 
		toolbar:"#mytbar",
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true,
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		remoteSort:false,  //定义是否从服务器排序数据。true
		onClickRow:function(index,row){
			//$('#knoExe').css('display','none'); 
			$("#mypropertylist").hide();
			$('mygrid').datagrid('selectRow', index);
			ClickFun();
			//$('#mygrid').datagrid('selectRow', index)
		},
		onDblClickRow:function(rowIndex,rowData){
			//双击事件
			$('.mytooltip').tooltip('hide');
			DblClickFun(rowIndex,rowData)

		},
		onRowContextMenu: function(e, rowIndex, rowData){   //右键菜单
			var $clicked=$(e.target);
			copytext =$clicked.text()||$clicked.val()   //普通复制功能
			e.preventDefault();  //阻止浏览器捕获右键事件
			$(this).datagrid("selectRow", rowIndex); //根据索引选中该行  

            copyfieldname = $clicked.closest('td').attr('field');
  
            copyfieldval=rowData[copyfieldname]
            
     		//只有表达式单元格才有右键菜单		
            var expflag=""
			for(fieldid in expressInfoArr) {
				var comId="Extend"+fieldid
				copyfieldbase=expressInfoArr[fieldid]
				if(copyfieldname==comId){
					expflag="Y"
					break			
				}
			} 
			if (expflag=="Y"){
				$('#myMenu').menu('show', {    
					  left:e.pageX,  
					  top:e.pageY
				})
				copyfieldval=rowData[copyfieldname+"F"]
				copyfieldtext=rowData[copyfieldname]
			}
			
			//科室常用诊断右键-查看知识点、复制到科室专业诊断按钮
			var record = $("#basegrid").datagrid("getSelected"); 
			if (record)
			{	
				var MKBKMBDesc=record.MKBKMBDesc;  //标题
				if (MKBKMBDesc=="科室常用诊断")
				{
				 	var mygridmm = $('<div style="width:180px;"></div>').appendTo('body');
		            mygridmm.html(					  
				        '<div onclick="ReadKon()" id="kno_menu" iconCls="icon-productimage" data-options="">相关知识点</div>'+
				       	'<div onclick="CopyToSpecLoc()" id="copyto_menu"  iconCls="icon-copyorder" data-options="">复制到科室专业诊断</div>'
					).click(stopPropagation);
					 mygridmm.menu({
					 	 onClick:function(item){
						  }
					});
	  				mygridmm.menu('show',{
		                left:e.pageX,
		                top:e.pageY
		            });
					
				}
				if (MKBKMBDesc=="科室专业诊断")
				{
					
				 	var mygridmm = $('<div style="width:180px;"></div>').appendTo('body');
		            mygridmm.html(					  
				        '<div onclick="ReadKon()" id="kno_menu" iconCls="icon-productimage" data-options="">相关知识点</div>'
					).click(stopPropagation);
					mygridmm.menu({
					 	 onClick:function(item){
						  }
					});
					mygridmm.menu('show',{
		                left:e.pageX,
		                top:e.pageY
		            });
				}
			}

			

		},
		onLoadSuccess:function(){
			//悬浮提示
			//showTextareaTip()
			//$(this).datagrid('columnMoving');
			/*$('.mytooltip').tooltip({
				trackMouse:true,
				onShow:function(e){
					$(this).tooltip('tip').css({
						width:250 ,top:e.pageY+20,left:e.pageX-(250/2)
					});
				}

			});*/
			$('.mytooltip').each(function(){
		    	var _yy=$(this).offset().top;
		    	if($(window).height()-_yy<100){
			    	$(this).tooltip({
				    	position:'top',
				    	trackMouse:true,
				    	onShow:function(e){
							$(this).tooltip('tip').css({
								width:500 ,left:e.pageX-(500/2)
							});
							if($(this).tooltip('tip').height()>400){
								$(this).tooltip('tip').css({
									width:700 ,top:e.pageY+40,left:e.pageX-(700/2)
								});
							}
						}
				    })
			    }
			    else{
					$(this).tooltip({
				    	trackMouse:true,
				    	onShow:function(e){
							$(this).tooltip('tip').css({
								width:500 ,left:e.pageX-(500/2)
							});
							if($(this).tooltip('tip').height()>400){
								$(this).tooltip('tip').css({
									width:700 ,top:e.pageY-40,left:e.pageX-(700/2)
								});
							}
						}
				    })
				}
		    })
		}
	});
		
		
	//生成中间列表
	InitMyGrid=function ()
	{
		options={};  
		if (termRowId!="")
		{
			options.url = QUERY_ACTION_URL_BYTERMID;  
			options.queryParams = {  
				MBRowId:base,
				TermId:termRowId,
				TBRowId:termBase
			}; 
			
		}
		else if(detailIdStr!="")
		{
			options.url = QUERY_ACTION_URL_BYTERMEXP;
			options.queryParams = {  
				MBRowId:base,
				Exp:detailIdStr
			}; 
		}
		else
		{
			options.url = QUERY_ACTION_URL;  		
			options.queryParams = {  
				base:base
			}; 
		}
		options.pageNumber=1;
		options.columns = CreateColumns();
		options.sortName = "";  //定义可以排序的列。
		//options.title=gridTitle;
		//alert(base)
		options.ClassTableName=HISUI_ClassTableName+base;
		options.SQLTableName=HISUI_SQLTableName; 
		
		//ShowUserHabit('mygrid');
		$('#mygrid').datagrid(options);  
	}
	
	///查询按钮
	$('#TextDesc').searchbox({
		searcher:function(value,name){
			//alert(value + "," + name)
			SearchFunLib();
		}
	})
	
	//检索框单击选中输入内容
	$('#TextDesc').searchbox('textbox').bind('click',function(){
		$('#TextDesc').searchbox('textbox').select()         
	 })
	 
	///重置按钮
	$("#btnRefresh").click(function (e) { 
		ClearFunLib();
	 }) 
 
	///添加按钮
	$("#add_btn").click(function (e) { 
		AddData();
	}) 
	
	///保存按钮
	$("#save_btn").click(function (e) { 
		SaveFunLib();
	}) 
	
	///删除按钮
	$("#del_btn").click(function (e) { 
		DelData();
	})  
	
	///导入按钮
	$("#btnDataImport").click(function (e) { 
		DataImport();
	})  
	 	
	//右键删除表达式
	$("#del_menu").click(function(e){
		DeleteText();
	})	
	//右键复制表达式
	$("#copy_menu").click(function(e){
		CopyText();
	})
	//右键粘贴表达式
	$("#paste_menu").click(function(e){
		PasteText();
	})
	//上传文献按钮
    $('#upload_btn').click(function (e){
        UploadDoc();
    });
    	
	//科室常用诊断右键-查看相关知识点按钮
	/*$("#kno_menu").click(function(e){
		ReadKon();	
	})
	
	//科室常用诊断右键-复制到科室专业诊断按钮
	$("#copyto_menu").click(function(e){
		CopyToSpecLoc();
	})*/
	
	//修改完后给这一行赋值
	/*function UpdataRow(Index,id){
		$.ajax({
			url:QUERY_ACTION_URL,
			data:{
				"base":base,
				"rowid":id
			},
			type:'POST',
			success:function(data){
				var datajson=eval('(' + data + ')');
				//alert(datajson.rows[0])
				$('#mygrid').datagrid('updateRow',{
					index: Index,
					row:datajson.rows[0]
				})
				//悬浮提示
				$('.mytooltip').tooltip();
			}
		});
		
	}*/
	
	$('.datagrid-pager').find('a').each(function(){
		$(this).click(function(){
			//$('#knoExe').css('display','none'); 
			$("#mypropertylist").hide();
			editIndex = undefined;
			rowsvalue=undefined;
			oldrowsvalue=undefined;
			preeditIndex="";
		})
	})
	
	//用于单击非grid行保存可编辑行
	/*$(document).bind('click',function(){ 
	    ClickFun()
	});*/ 
	
	
	///***************************************增删改查基本操作区（开始）**************************************************/
	function AppendDom(){
		if (editIndex!=undefined)
		{
			var col=$('#layoutcenter').children().find('tr[datagrid-row-index='+editIndex+']')[1];
	        $(col).find('table').each(function(){
				var target=$(this).find('input:first')
				if(target.css('display')=='none'){
					target.next().find('input:first').click(function(){
						//$('#knoExe').css('display','none');
						$("#mypropertylist").hide();
					})
				}
				else{
					target.click(function(){
						//$('#knoExe').css('display','none'); 
						$("#mypropertylist").hide();
					})
				}
			})	  
							
			//加载表达式控件
			for(fieldid in expressInfoArr) {
				var comId="Extend"+fieldid
				var baseId=expressInfoArr[fieldid]
				//var ed=$("#mygrid").datagrid("getEditor",{index:editIndex,field:comId});
				//ed.target.prop('readonly', true);
				CreateExpDom(col,comId,baseId)

			}
			
			//加载多行文本框控件
			for(fieldid in textareInfoArr) {
				var comId="Extend"+fieldid
				CreateTADom(col,comId)			
			}
			
			//设置知识点不可编辑 2018-06-20
			if (noEditChildK1!="")
			{
				var q1Str = noEditChildK1.split(","); 
				for (var q1 = 0; q1 <q1Str.length; q1++) {
					var ed=$("#mygrid").datagrid("getEditor",{index:editIndex,field:"Extend"+q1Str[q1]});
					var val=$(ed.target).val()
					val=val.replace(/<br\/>/g,"");
					$(ed.target).val(val)
					ed.target.prop('readonly', true);
				}
			}
			if (noEditChildK2!="")
			{
				var q2Str = noEditChildK2.split(","); 
				for (var q2 = 0; q2 <q2Str.length; q2++) {
					var ed=$("#mygrid").datagrid("getEditor",{index:editIndex,field:"Extend"+q2Str[q2]});
					var val=$(ed.target).val()
					val=val.replace(/<br\/>/g,"");
					$(ed.target).val(val)
					ed.target.prop('readonly', true);
				}
			}
		}
	} 
	
	//判断是否是数字
	function isNumber(value) {
	    var patrn = /^[0-9]*$/;
	    if (patrn.exec(value) == null || value == "") {
	        return false
	    } else {
	        return true
	    }
	}

	//修改完后给这一行赋值
	function UpdataRow(row,Index,TAType){	

		//知识点可编辑控件
		for(fieldid in sourseInfoArr) {
			var comId="Extend"+fieldid
			var comIdF="Extend"+fieldid+"F"
		    var temp;
		    if (isNumber(row[comIdF])||isNumber(row[comId]))
		    {
				temp=row[comId]
				row[comId]=row[comIdF]
				row[comIdF]=temp
		    }
		    else
		    {
		    	row[comId]=""
		    	row[comIdF]=""
		    }
		}
		
		//处理换行符
		if(TAType=="1")   //双击的时候</br>转换为\n
		{
			//多行文本框
			for(fieldid in textareInfoArr) {
				var comId="Extend"+fieldid
				row[comId]=row[comId].replace(/<br\/>/g,"\n");   	
			}	
		}
		else   //保存成功的时候\n转换为</br>
		{
				//多行文本框
			for(fieldid in textareInfoArr) {
				var comId="Extend"+fieldid
				row[comId]=row[comId].replace(/\n/g,"<br\/>");   	
			}		
		}
		//console.log(row)
		
		$('#mygrid').datagrid('updateRow',{
			index: Index,
			row:row
		})
		
		/*$('.mytooltip').tooltip({
				trackMouse:true,
				onShow:function(e){
					$(this).tooltip('tip').css({
						width:250 ,top:e.pageY+20,left:e.pageX-(250/2)
					});
				}

			});*/
		$('.mytooltip').each(function(){
		    	var _yy=$(this).offset().top;
		    	if($(window).height()-_yy<100){
			    	$(this).tooltip({
				    	position:'top',
				    	trackMouse:true,
				    	onShow:function(e){
							$(this).tooltip('tip').css({
								width:500 ,left:e.pageX-(500/2)
							});
							if($(this).tooltip('tip').height()>400){
								$(this).tooltip('tip').css({
									width:700 ,top:e.pageY+40,left:e.pageX-(700/2)
								});
							}
						}
				    })
			    }
			    else{
					$(this).tooltip({
				    	trackMouse:true,
				    	onShow:function(e){
							$(this).tooltip('tip').css({
								width:500 ,left:e.pageX-(500/2)
							});
							if($(this).tooltip('tip').height()>400){
								$(this).tooltip('tip').css({
									width:700 ,top:e.pageY-40,left:e.pageX-(700/2)
								});
							}
						}
				    })
				}
		    })
	}
	

	
	//是否有正在编辑的行true/false
	function endEditing(){
		if (editIndex == undefined){return true}
		if ($('#mygrid').datagrid('validateRow', editIndex)){
			$('#mygrid').datagrid('endEdit', editIndex);
			rowsvalue=mygrid.getRows()[editIndex];
			//editIndex = undefined;
			return true;
		} else {
			return false;
		}
	}  
	
	//grid单击事件
	function ClickFun(saveType){   //单击执行保存可编辑行
		if (endEditing()){
			if(rowsvalue!= undefined){
				//if((rowsvalue.MKBTPDDesc!="")){
					var differentflag="";
					if(oldrowsvalue!= undefined){
						var oldrowsvaluearr=JSON.parse(oldrowsvalue)
						for(var params in rowsvalue){
							if(oldrowsvaluearr[params]==undefined){oldrowsvaluearr[params]=""}
							if(rowsvalue[params]==undefined){rowsvalue[params]=""}	
							var nowVlaue=rowsvalue[params]
							nowVlaue=nowVlaue.replace(/<br\/>/g,"");
							var oldVlaue=oldrowsvaluearr[params]
							oldVlaue=oldVlaue.replace(/<br\/>/g,"");
							if(oldVlaue!=nowVlaue){
								differentflag=1
							}
						}
					}
					else{
						differentflag=1
					}
					if(differentflag==1){
						preeditIndex=editIndex
						SaveData(rowsvalue,saveType);
					}
					else{
						UpdataRow(rowsvalue,editIndex)
						editIndex=undefined
						rowsvalue=undefined
					}
				/*}
				else{
					$.messager.alert('错误提示',propertyName+'不能为空!',"error");
					$('#mygrid').datagrid('selectRow', editIndex)
						.datagrid('beginEdit', editIndex);
					AppendDom()
					return
				}*/
			}

		}
	}

	//grid双击事件
	function DblClickFun (index,row){   //双击激活可编辑   （可精简）		
		if(index==editIndex){
			return
		}
		if((row!=undefined)&&(row.MKBKMDRowNum!=undefined)){
			UpdataRow(row,index,"1")
		}
		preeditIndex=editIndex
		if (editIndex != index){
			if (endEditing()){
				$('#mygrid').datagrid('selectRow', index)
						.datagrid('beginEdit', index);
				editIndex = index;
			} else {
				$('#mygrid').datagrid('selectRow', editIndex);
			}
		}
		oldrowsvalue=JSON.stringify(row);   //用于和rowvalue比较 以判断是否行值发生改变
		AppendDom()
		
		// 引用类型的下拉框双击时只加载一条数据
		for(urlChild in urlArr) {
			var TFlag=""
			var url=urlArr[urlChild]
			if (urlChild.indexOf("T")>-1)
			{
				urlChild=urlChild.split("T")[1]			
				TFlag="Y"
			}
			var ed =  $("#mygrid").datagrid("getEditor",{index:index,field:"Extend"+urlChild});	
			var comId="Extend"+urlChild;
			var idF =row[comId]	
			if ((idF!="")&(idF!=undefined)){
				url=url+"&rowid="+idF
				if (TFlag=="Y")
				{
					$(ed.target).combotree('reload',url);
				}
				else
				{
					$(ed.target).combobox('reload',url);
				}
			}	
		}
	}
	
	//点击新增按钮后新增一行
	function AddData(){
		preeditIndex=editIndex;
		ClickFun('AddData')
		if (endEditing()){
			$('#mygrid').datagrid('insertRow',{index:0,row:{}});
			editIndex = 0;//$('#mygrid').datagrid('getRows').length-1;
			$('#mygrid').datagrid('selectRow', editIndex)
					.datagrid('beginEdit', editIndex);
		}
		$('.eaitor-label span').each(function(){	                    
            $(this).unbind('click').click(function(){
                if($(this).prev()._propAttr('checked')){
                    $(target).combobox('unselect',$(this).attr('value'));

                }
                else{
	                $(target).combobox('select',$(this).attr('value'));
	            }
            })
        });
  
        
		//新增时为知识点单元格赋值
        if (termRowId!="")
        {
			for(fieldid in defaultData) {
				var ed=$("#mygrid").datagrid("getEditor",{index:editIndex,field:"Extend"+fieldid});	
				var edF=$("#mygrid").datagrid("getEditor",{index:editIndex,field:"Extend"+fieldid+"F"});	
				var comType=defaultData[fieldid]
				if (comType=="L")
				{
					$(ed.target).combobox('setValue',termRowId)	
					$(ed.target).combobox('setText',termDesc)
					$(edF.target).val(termDesc)
				}
				else if(comType=="T")
				{
					
					$(ed.target).combotree('setValue',termRowId)	
					$(ed.target).combotree('setText',termDesc)
					$(edF.target).val(termDesc)		
				}
				else
				{
					$(ed.target).val(termDesc)	
					$(edF.target).val(termRowId)
				}
			}	
        }
        
        //新增时为表达式单元格赋值
        if ((detailIdStr!="")&(termBase!=""))
        {
	        for(fieldid in expressInfoArr) {
				//如果映射配置项=知识点1或知识点2
				if ((expressInfoArr[fieldid]==termBase))
				{	
					var ed=$("#mygrid").datagrid("getEditor",{index:editIndex,field:"Extend"+fieldid});	
					var edF=$("#mygrid").datagrid("getEditor",{index:editIndex,field:"Extend"+fieldid+"F"});	
					//$(ed.target).val(detailDescStr)	
					$(ed.target).combogrid('setValue', detailDescStr)
					$(edF.target).val(detailIdStr)
					break;
				}
			}
		}
		
							

        //加载多行文本框和表达式控件
		AppendDom()
	}
	
	//点击保存按钮后调用此方法

	function SaveFunLib(){
		var ed = $('#mygrid').datagrid('getEditors',editIndex); 
		if(ed!=""){
			preeditIndex=editIndex;
			if (endEditing()){
				var record=mygrid.getSelected();
				//console.log(record)	  
				//return
				SaveData(record);
			}
		}
		else{
			$.messager.alert('警告','请双击选择一条数据！','warning')
		}
	}
	
	///保存方法
	function SaveData(record,saveType){
		
		var baseRecord = $("#basegrid").datagrid("getSelected"); 
		if (!(baseRecord))
		{	
			return;
		}
		var extendChild =baseRecord.extendChild;  //扩展属性child串
		var extendType =baseRecord.extendType;    //扩展属性格式串
		var extendConfig =baseRecord.extendConfig;    //扩展属性配置项串
		
		//获取所有扩展属性的值
		var extendValue=""
		var allValue=""
		var col1val=""  //列1的值
		var col2val=""  //列2的值
		if (extendChild!="")   //如果有扩展属性
		{
			var colsField = extendChild.split("[N]"); 
			var typeStr = extendType.split("[N]"); 
			var configStr = extendConfig.split("[N]"); 

			for (var i = 0; i <colsField.length; i++) 
			{
				var childid="Extend"+colsField[i]
				var type=typeStr[i]
				var child=colsField[i]
				var configInfos=configStr[i]  //配置项
				var extProValue=record[childid]	  //获取可编辑列表的值
			
				if(configInfos=="Exp")  //表达式
				{
					if (extProValue!="")
					{
						extProValue=record[childid+"F"]	  //获取可编辑列表的值
						//var detail=tkMakeServerCall('web.DHCBL.MKB.MKBKLMappingDetail','GetExpDesc',extProValue)
						//record[childid]=detail
					}
				}
				//alert(extProValue)
				if ((extProValue=="undefined")||(extProValue==null)){extProValue=""}
				
				if(type=="CB")  //复选框,用","连接替换成用"&%"
				{
					if (extProValue!="")
					{
						extProValue=extProValue.replace(/\,/g,"&%")
					}
				}
				
							
				if (extendValue!="")
				{
					var extendValue=extendValue+"[N]"+child+"[A]"+extProValue
				}
				else
				{
					var extendValue=child+"[A]"+extProValue
				}
				allValue=allValue+extProValue
				
				if (i==0)
				{
					col1val=extProValue
				}
				if (i==1)
				{
					col2val=extProValue
				}
				
			}
		}
		
		if (allValue=="")
		{					
			$.messager.alert('错误提示','行数据不能为空!',"error");
			$('#mygrid').datagrid('selectRow', editIndex)
					.datagrid('beginEdit', editIndex);
			AppendDom()
			return;
		}
		if ((col1val=="")&(col2val==""))
		{
			$.messager.alert('错误提示','前两列不能同时为空!',"error");
			$('#mygrid').datagrid('selectRow', editIndex)
					.datagrid('beginEdit', editIndex);
			AppendDom()
			return;		
		}
		//console.log(record);
		//执行保存
		$.ajax({
			type: 'post',
			url: SAVE_ACTION_URL,
			data:{
				"rowNum":record.MKBKMDRowNum,
				"base":base,
				"fieldValueStr":extendValue
			}, 
			success: function (data) { //返回json结果			
				var data=eval('('+data+')');
				if(data.success=='true'){
				  /*$.messager.show({
					title:'提示信息',
					msg:'保存成功',
					showType:'show',
					timeout:1000,
					style:{
					  right:'',
					  bottom:''
					}
				  })*/
				  $.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
				  
				  //备注悬浮提示
				  if(saveType=='AddData'){
				      preeditIndex=preeditIndex+1;
				  }
				  //alert(saveType+"&"+preeditIndex)
				  record.MKBKMDRowNum=data.id
				  UpdataRow(record,preeditIndex);
				  if(saveType!='AddData'){
						editIndex=undefined
						rowsvalue=undefined
					}
				}
				else{
					var errorMsg="保存失败！";
					if(data.errorinfo){
						errorMsg=errorMsg+'</br>错误信息:'+data.errorinfo
					}
					$.messager.alert('错误提示',errorMsg,'error',function(){
						UpdataRow(record,preeditIndex)
			       		editIndex=undefined
			       		DblClickFun (preeditIndex,record);
			        })
			   }
			}
		});

	}
	
	 ///查询方法
	SearchFunLib=function()
	{
		var desc=$.trim($('#TextDesc').searchbox('getValue'));
		var allEn=""
		if(desc.match("^[a-zA-Z 0-9]+$")){ //如果是英文或数字
			allEn="Y"
		}
		if (termRowId!="")
		{
			$('#mygrid').datagrid('load',  { 
				MBRowId:base,
				TermId:termRowId,
				TBRowId:termBase,
				'desc':desc,
				'searchConfigs':searchConfigs,
				'unsearchConfigs':unsearchConfigs,
				'allEn':allEn
			});
			
		}
		else if(detailIdStr!="")
		{
			$('#mygrid').datagrid('load',  {   
				MBRowId:base,
				Exp:detailIdStr,
				'desc':desc,
				'searchConfigs':searchConfigs,
				'unsearchConfigs':unsearchConfigs,
				'allEn':allEn
			});
		}
		else
		{
			$('#mygrid').datagrid('load',  {		
				'desc':desc,	
				'base':base,
				'searchConfigs':searchConfigs,
				'unsearchConfigs':unsearchConfigs,
				'allEn':allEn
			});
		}
		$('#mygrid').datagrid('unselectAll');
	}
	
	///重置方法
	ClearFunLib=function()
	{
		editIndex = undefined;  //正在编辑的行index
		rowsvalue=undefined;   //正在编辑的行数据
		
		$("#TextDesc").searchbox('setValue', '');
		if (termRowId!="")
		{
			$('#mygrid').datagrid('load',  { 
				MBRowId:base,
				TermId:termRowId,
				TBRowId:termBase
			});
			
		}
		else if(detailIdStr!="")
		{
			$('#mygrid').datagrid('load',  {   
				MBRowId:base,
				Exp:detailIdStr
			});
		}
		else
		{
			$('#mygrid').datagrid('load',  { 
				'base':base
			});
		}
		$('#mygrid').datagrid('unselectAll');
	}
	
	///删除
	DelData=function()
	{        
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		
		if((record.MKBKMDRowNum==undefined)||(record.MKBKMDRowNum=="")){
			mygrid.deleteRow(editIndex)
			editIndex = undefined;
			rowsvalue=undefined;   //正在编辑的行数据
			return;
		}		
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
			if (r){	
				$.ajax({
					url:DELETE_ACTION_URL,  
					data:{
						"id":record.MKBKMDRowNum,     ///rowid
						"base":base      
					},  
					type:"POST",   
					success: function(data){
							  var data=eval('('+data+')'); 
							  if (data.success == 'true') {
									/*$.messager.show({ 
									  title: '提示消息', 
									  msg: '删除成功', 
									  showType: 'show', 
									  timeout: 1000, 
									  style: { 
										right: '', 
										bottom: ''
									  } 
									}); */
							  	    $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
									$('#mygrid').datagrid('reload');  // 重新载入当前页面数据  
									$('#mygrid').datagrid('unselectAll');  // 清空列表选中数据
									editIndex = undefined;
									rowsvalue=undefined;
							  } 
							  else { 
									var errorMsg ="删除失败！"
									if (data.info) {
										errorMsg =errorMsg+ '<br/>错误信息:' + data.info
									}
									$.messager.alert('操作提示',errorMsg,"error");
					
							}			
					}  
				})
			}
		});
	}
	
	//2019-08-28 chenying 数据导入
	DataImport=function(){
		$("#myWinDataImport").show(); 
		var url="dhc.bdp.mkb.mkbdataimportpanel.csp?base="+base+"&type=M" 
		if ('undefined'!==typeof websys_getMWToken){
			url += "&MWToken="+websys_getMWToken()
		}
		var myWinDataImport = $HUI.window("#myWinDataImport",{
			iconCls:'icon-w-paper',
			resizable:true,
			collapsible:false,
			minimizable:false,
			title:'数据导入导出',
			modal:true,
			content:'<iframe id="timeline" frameborder="0" src="'+url+'" width="100%" height="99%" scrolling="no"></iframe>'
		});	
	} 
	
	///***************************************增删改查基本操作区（结束）**************************************************/
	
	///***************************************右键功能区（开始）**************************************************/
	///右键复制
    CopyText=function(){
    	var aux = document.createElement("input");
		// 获取复制内容
		//var content =elementId.text()||elementId.val() 
		// 设置元素内容
		aux.setAttribute("value", copytext);

		// 将元素插入页面进行调用
		document.body.appendChild(aux);

		// 复制内容
		aux.select();

		// 将内容复制到剪贴板
		document.execCommand("copy");

		// 删除创建元素
		document.body.removeChild(aux);
		
		pastefieldname = copyfieldname
		pastefieldval= copyfieldval
		pastefieldtext= copyfieldtext
		pastefieldbase=copyfieldbase
		//alert(pastefieldname+"&&"+pastefieldval+"&&"+pastefieldbase)
		//提示
		//alert("复制内容成功：" + aux.value);
    	
    }	
    
   //右键操作后更新行数据
	function UpdataRowAfterRightAct(row,Index){	
		//知识点可编辑控件		
		$('#mygrid').datagrid('updateRow',{
			index: Index,
			row:row
		})
		
		/*$('.mytooltip').tooltip({
			trackMouse:true,
			onShow:function(e){
				$(this).tooltip('tip').css({
					width:250 ,top:e.pageY+20,left:e.pageX-(250/2)
				});
			}

		});*/
		$('.mytooltip').each(function(){
		    	var _yy=$(this).offset().top;
		    	if($(window).height()-_yy<100){
			    	$(this).tooltip({
				    	position:'top',
				    	trackMouse:true,
				    	onShow:function(e){
							$(this).tooltip('tip').css({
								width:500 ,left:e.pageX-(500/2)
							});
							if($(this).tooltip('tip').height()>400){
								$(this).tooltip('tip').css({
									width:700 ,top:e.pageY+40,left:e.pageX-(700/2)
								});
							}
						}
				    })
			    }
			    else{
					$(this).tooltip({
				    	trackMouse:true,
				    	onShow:function(e){
							$(this).tooltip('tip').css({
								width:500 ,left:e.pageX-(500/2)
							});
							if($(this).tooltip('tip').height()>400){
								$(this).tooltip('tip').css({
									width:700 ,top:e.pageY-40,left:e.pageX-(700/2)
								});
							}
						}
				    })
				}
		    })
	}
	
    ///右键粘贴
    PasteText=function(){	
    	//列和要赋值的值
		//alert(copyfieldname+"&&"+pastefieldval)
		if (copyfieldbase!=pastefieldbase){
			$.messager.alert('错误提示','不同的知识点，不能粘贴到本列!',"error");
			return;
		}
		
		var record = $("#mygrid").datagrid("getSelected"); 
		if (record)
		{
			//执行保存
			$.ajax({
				type: 'post',
				url: SAVE_CELL_ACTION_URL,
				data:{
					"rowNum":record.MKBKMDRowNum,
					"base":base,
					"child":copyfieldname,
					"fieldValue":pastefieldval
				}, 
				success: function (data) { //返回json结果			
					var data=eval('('+data+')');
					if(data.success=='true'){
					  /*$.messager.show({
						title:'提示信息',
						msg:'保存成功',
						showType:'show',
						timeout:1000,
						style:{
						  right:'',
						  bottom:''
						}
					  })*/
					  $.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
					  record[copyfieldname]=pastefieldtext
					  record[copyfieldname+"F"]=pastefieldval
					  UpdataRowAfterRightAct(record,$('#mygrid').datagrid('getRowIndex', record))
					}
					else{
						DblClickFun(editIndexvalue)
						var errorMsg="保存失败！";
						if(data.errorinfo){
							errorMsg=errorMsg+'</br>错误信息:'+data.errorinfo
						}
						$.messager.alert('错误提示',errorMsg,'error')
				   }
				}
			});	
		}
    	
    }
    
    ///右键删除
    DeleteText=function(){	
    	//列和要赋值的值
		var record = $("#mygrid").datagrid("getSelected"); 
		if (record)
		{		
			//执行保存
			$.ajax({
				type: 'post',
				url: DELETE_CELL_ACTION_URL,
				data:{
					"rowNum":record.MKBKMDRowNum,
					"base":base,
					"child":copyfieldname
				}, 
				success: function (data) { //返回json结果			
					var data=eval('('+data+')');
					if(data.success=='true'){
					  /*$.messager.show({
						title:'提示信息',
						msg:'删除成功',
						showType:'show',
						timeout:1000,
						style:{
						  right:'',
						  bottom:''
						}
					  })*/
					  $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					  record[copyfieldname]=""
					  record[copyfieldname+"F"]=""
					  UpdataRowAfterRightAct(record,$('#mygrid').datagrid('getRowIndex', record))
					}
					else{
						DblClickFun(editIndexvalue)
						var errorMsg="删除失败！";
						if(data.errorinfo){
							errorMsg=errorMsg+'</br>错误信息:'+data.errorinfo
						}
						$.messager.alert('错误提示',errorMsg,'error')
				   }
				}
			});	
		}
    	
    }  
    //科室常用诊断右键-查看相关知识点按钮
    ReadKon=function(){
    	var baseRecord = $("#basegrid").datagrid("getSelected"); 
		if (!(baseRecord))
		{	
			return;
		}
		var K2Child =baseRecord.K2Child;  //诊断列的child
		
    	var record = $("#mygrid").datagrid("getSelected"); 
    	if (!(record))
		{	
			return;
		}
		var child2Col="Extend"+K2Child+"F"
		var termid =record[child2Col]  //诊断列的值

		var menuid=tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetID","dhc.bdp.mkb.mtm.Diagnosis");
		var parentid="";  //父节点ID
		var menuimg="";  //图片
		//判断浏览器版本
		var Sys = {};
		var ua = navigator.userAgent.toLowerCase();
		var s;
		(s = ua.match(/msie ([\d.]+)/)) ? Sys.ie = s[1] :
		(s = ua.match(/firefox\/([\d.]+)/)) ? Sys.firefox = s[1] :
		(s = ua.match(/chrome\/([\d.]+)/)) ? Sys.chrome = s[1] :
		(s = ua.match(/opera.([\d.]+)/)) ? Sys.opera = s[1] :
		(s = ua.match(/version\/([\d.]+).*safari/)) ? Sys.safari = s[1] : 0;
		//双击时跳转到对应界面
		if(!Sys.ie){
			if(termRowId!="")  //如果是属性内容模块展示
			{
				window.parent.parent.closeNavTab(menuid)
				window.parent.parent.showNavTab(menuid,"诊断学_临床实用诊断",'dhc.bdp.ext.sys.csp?BDPMENU='+menuid+"&TermID="+termid+"&ProId=",parentid,menuimg)				
			}
			else  //在规则管理界面
			{
				window.parent.closeNavTab(menuid)
				window.parent.showNavTab(menuid,"诊断学_临床实用诊断",'dhc.bdp.ext.sys.csp?BDPMENU='+menuid+"&TermID="+termid+"&ProId=",parentid,menuimg)
			}
		}else{
			parent.PopToTab(menuid,"诊断学_临床实用诊断",'dhc.bdp.ext.sys.csp?BDPMENU='+menuid+"&TermID="+termid+"&ProId=",menuimg);
		}

    	
    }
    
    //科室常用诊断右键-复制到科室专业诊断按钮
    CopyToSpecLoc=function(){
    	var record = $("#mygrid").datagrid("getSelected"); 
    	if (record)
		{	
			$.ajax({
				type: 'post',
				url: CopyToSpecLoc_ACTION_URL,
				data:{
					"id":record.MKBKMDRowNum,
					"base":base
				}, 
				success: function (data) { //返回json结果			
					var data=eval('('+data+')');
					if(data.success=='true'){
					  $.messager.popover({msg: '复制成功！',type:'success',timeout: 1000});
					}
					else{
						var errorMsg="复制失败！";
						if(data.errorinfo){
							errorMsg=errorMsg+'</br>错误信息:'+data.errorinfo
						}
						$.messager.alert('错误提示',errorMsg,'error')
				   }
				}
			});	
		}
    }
    
    ///******************************文献上传功能***********************************************/
   //审核下拉框
    var modeCmb = $HUI.combobox("#MKBDMFlag",{
        valueField:'id',
        textField:'text',
        data:[
            {id:'F',text:'初传'},
            {id:'Y',text:'审核通过'},
            {id:'N',text:'审核未通过'}
        ],
        panelHeight:100
    });
    
    //点击上传文献按钮
    function UploadDoc() {
        $("#docWin").show();
		setTimeout(function(){
			$('#MKBDMDesc').focus();
		},200)
       // $('#upload').show();//防止修改时将上传隐藏
       // $('#txtchooses').show();
        var docWin = $HUI.dialog("#docWin",{
            iconCls:'icon-w-paper',
            resizable:true,
            title:'上传文献',
            modal:true,
            buttonAlign : 'center',
            buttons:[{
                text:'保存',
                id:'save_doc_btn',
                handler:function(){
                  SaveUploadDoc()
                }
            },{
                text:'关闭',
                handler:function(){
                    docWin.close();
                }
            }]
        });
        $('#form-save').form("clear");
        //字动生成文献的code，默认只读不可修改
        $.m({
            ClassName:"web.DHCBL.MKB.MKBDocManage",
            MethodName:"GetLastCode"
        },function(txtData){
            $('#MKBDMCode').val(txtData);
        });
        //审核状态默认初传
        var per="F";
        $('#MKBDMFlag').combobox('setValue',per);
    }
    
   ///新增、更新
    function SaveUploadDoc()
    {
        var code=$.trim($("#MKBDMCode").val());
        var desc=$.trim($("#MKBDMDesc").val());
        var path=$.trim($("#MKBDMPath").val());
        if (code=="")
        {
            $.messager.alert('错误提示','代码不能为空!',"error");
            return;
        }
        if (desc=="")
        {
            $.messager.alert('错误提示','名称不能为空!',"error");
            return;
        }
        if (path=="")
        {
            $.messager.alert('错误提示','请先上传文件!',"error");
            return;
        }
        $('#form-save').form('submit', {
            url: SAVE_DOC_ACTION_URL,
            onSubmit: function(param){
            	param.mappingBase=mappingBase;
            	param.termBase=termBase;
            	param.detailIdStr=detailIdStr;
            },
            success: function (data) {
                var data=eval('('+data+')');
                if (data.success == 'true') {

                    var fileName=$('#MKBDMPath').val();
                    var pp = fileName.split(".")[fileName.split(".").length-1];
                    if((pp=="doc")||(pp=="docx")||(pp=="xls")||(pp=="xlsx"))
                    {
                        $.ajax({
                            url : PREVIEW_FILE_URL,
                            method : 'POST',
                            data : {
                                path: "D:\\DTHealth\\app\\dthis\\web\\scripts\\bdp\\MKB\\Doc\\Doc\\"+fileName
                            },
                            success: function(){
                                /*$.messager.show({
                                    title: '提示消息',
                                    msg: '预览文件生成成功',
                                    showType: 'show',
                                    timeout: 1000,
                                    style:{
                                        right: '',
                                        bottom: ''
                                    }
                                })*/
                            	$.messager.popover({msg: '预览文件生成成功！',type:'success',timeout: 1000});
                            }
                        });
                    }
                    
                    /*$.messager.show({
                        title: '提示消息',
                        msg: '提交成功',
                        showType: 'show',
                        timeout: 1000,
                        style: {
                            right: '',
                            bottom: ''
                        }
                    });*/
                    $.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
                    $('#docWin').dialog('close'); // close a dialog
                    if (detailIdStr!=""){
                   		 ClearFunLib();
                    }
                }
                else {
                    var errorMsg ="更新失败！"
                    if (data.errorinfo) {
                        errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
                    }
                    $.messager.alert('操作提示',errorMsg,"error");

                }

            }
        });
    }
	
    ///******************************文献上传功能(完)***********************************************/
    
    ///***************************************右键功能区(结束)**************************************************/
    
     ///***************************************统一的封装控件——表达式和多行文本框(开始)**************************************************/
    
    	//诊断表达式下拉框
	var DisplayNameEditor={
		type:'combogrid',
		options:{
				panelWidth:380,
				panelHeight:240, //308
				delay: 500,    
				mode: 'remote',  
				//url:$URL+"?ClassName=web.DHCBL.MKB.MKBTermProDetail&MethodName=GetTermListForDoc&base=5",
				showHeader:false,
				fitColumns: false,   
				striped: true,   
				editable:true,   
				selectOnNavigation:false,
				rownumbers:false,//序号   
				collapsible:false,//是否可折叠的   
				fit: false,//自动大小   
				pagination : true,//是否分页   
				pageSize: 6,//每页显示的记录条数，默认为10   
				pageList: [6,8,15,30,100,300],//可以设置每页记录条数的列表   
				showPageList:false,
				method:'post', 
				idField: 'MKBTRowId',    
				textField: 'MKBTDesc',    
				columns: [[    
					{field:'MKBTDesc',title:'诊断名称',width:480,sortable:true,
						formatter:function(value,rec){ 
						    var tooltipText=value.replace(/\ +/g,"")
					    	var reg = new RegExp("[\\u4E00-\\u9FFF]+","g");
　　							var matchCondition=""
							if ((findCondition!="")&&(findCondition!=undefined)){
								if(reg.test(findCondition)){   //包含中文情况
								    matchCondition=findCondition
								}else{ //不含中文情况
								 	var pinyin=Pinyin.GetJPU(value)
								 	var indexSign=value.indexOf("(")
								 	pinyin=pinyin.substring(0,indexSign)+"("+pinyin.substring(indexSign,pinyin.length)+")" //拼音拼上括号
								 	var indexCondition=pinyin.indexOf(findCondition.toUpperCase())
								 	if (indexCondition>-1){
								 		matchCondition=value.substr(indexCondition,findCondition.length) //根据英文检索条件，获取中文
										}
									}
								}
							 if (matchCondition!=""){ //检索条件不为空，匹配检索条件，作颜色区分
								 var len=value.split(matchCondition).length;
							     var value1="";
							     for (var i=0;i<len;i++){
								 	var otherStr=value.split(matchCondition)[i];
								    if (i==0){
									     if (otherStr!=""){
										    value1=otherStr
										}
									}else{
									    value1=value1+"<font color='red'>"+matchCondition+"</font>"+otherStr;
									}
								 }
						     }else{ //检索条件为空时直接取值
						     	var value1=value;
						     }
						   	   //鼠标悬浮显示备注
								var MKBTNote=rec.MKBTNote
								MKBTNote=MKBTNote.replace(/\ /g, "")
								MKBTNote=MKBTNote.replace(/\>/g, "大于")
								if (MKBTNote!=""){
									value="<span class='hisui-tooltip' title="+MKBTNote+">"+value1+"</span>" 
								}else{
									value="<span class='hisui-tooltip' title="+tooltipText+">"+value1+"</span>" 
								}
			                    return value;     
			                } 
					},
					{field:'comDesc',title:'comDesc',width:80,sortable:true,hidden:true},
					{field:'MKBTCode',title:'诊断代码',width:80,sortable:true,hidden:true},
					{field:'MKBTRowId',title:'MKBTRowId',width:80,sortable:true,hidden:true}
				]],
				onBeforeLoad:function(param){
					if (searchNameCondition!=""){
						findCondition=searchNameCondition
						param = $.extend(param,{desc:searchNameCondition});
						return true;
					}else{
						findCondition=param.q;
						if(param.q!=null && param.q!=undefined && param.q!=''){
							param = $.extend(param,{desc:param.q});
							return true;
						}else{
							if(cbg!=null){
								param = $.extend(param,{desc:""});
								if(document.activeElement.tagName=="INPUT"){//修复没有检索条件时，点击下拉面板分页条，下拉面板消失
									cbg.combogrid('hidePanel');
								}
								return true;	
							}
						}
					}
				},
				/*onClickRow:function (rowIndex, rowData){
					var selected = cbg.combogrid('grid').datagrid('getSelected');  
					if (selected) { 
						ClickDiagCombo(selected.MKBTRowId,selected.MKBTCode,selected.MKBTDesc,selected.comDesc)
					}
				},*/
			   onShowPanel:function(){
			   		cbg = $(this);
			   		//诊断列表弹出时隐藏属性列表
			   		if($("#mypropertylist").is(":hidden")==false){
			   			$("#mypropertylist").hide();
			   		}
			   		cbg.combogrid('textbox').bind('click',function(){ //2018-11-02 重新点击时 默认之前输入的值为选中状态，方便删除
						var col=$('#layoutcenter').children().find('tr[datagrid-row-index='+editIndex+']');
						$(col).find('td[field=SDSDisplayName]').find("input").focus().select();
						searchNameCondition=cbg.combogrid('getText')
     					cbg.combogrid('grid').datagrid('reload');
     					searchNameCondition=""
					 })
					cbg.combogrid("options").keyHandler.up=function(){
						 //取得选中行
		                var selected = $(this).combogrid('grid').datagrid('getSelected');
		                if (selected) {
		                    //取得选中行的rowIndex
		                    var index = $(this).combogrid('grid').datagrid('getRowIndex', selected);
		                    //向上移动到第一行为止
		                    if (index > 0) {
		                       $(this).combogrid('grid').datagrid('selectRow', index - 1);
		                    }
		                } else {
		                    var rows = $(this).combogrid('grid').datagrid('getRows');
		                    $(this).combogrid('grid').datagrid('selectRow', rows.length - 1);
		                }
					}
					cbg.combogrid("options").keyHandler.down=function(){
						 //取得选中行
		                var selected = $(this).combogrid('grid').datagrid('getSelected');
		                if (selected) {
		                    //取得选中行的rowIndex
		                    var index = $(this).combogrid('grid').datagrid('getRowIndex', selected);
		                    //向下移动到当页最后一行为止
		                    if (index < $(this).combogrid('grid').datagrid('getData').rows.length - 1) {
		                        $(this).combogrid('grid').datagrid('selectRow', index + 1);
		                    }
		                } else {
		                    $(this).combogrid('grid').datagrid('selectRow', 0);
		                }
					}
			   		cbg.combogrid("options").keyHandler.enter=function(){
			   			var selected = $(this).combogrid('grid').datagrid('getSelected');  
	    				if (selected) { 
		               		//ClickDiagCombo(selected.MKBTRowId,selected.MKBTCode,selected.MKBTDesc,selected.comDesc);
	    					ClickDiagCombo(selected.MKBTRowId);
	    				}
					}
			    },
			    /*onHidePanel:function(){
				    setTimeout(function(){
				    	cbg=null;
				    	SelMRCICDRowid=$("#SelMKBRowId").val()
				    	indexTemplate=tkMakeServerCall("web.DHCBL.MKB.SDSStructDiagnos","GetPropertyIdByFlag",SelMRCICDRowid,"DT");;
				    	CreatPropertyDom(target,SelMRCICDRowid,"",indexTemplate);
				    },10)
				   
				},*/
			    onLoadSuccess:function(){
					//var col=$('#layoutcenter').children().find('tr[datagrid-row-index='+editIndex+']');
					//$(col).find('td[field=SDSDisplayName]').find("input").focus();//诊断列表获取焦点
				}
		} 
	}
	
	
	//诊断表达式下拉框诊断点击方法 MKBTRowId-诊断id
	function ClickDiagCombo(MKBTRowId){
	      SelMRCICDRowid=MKBTRowId; //诊断id
	      $("#SelMKBRowId").val(SelMRCICDRowid);
	      $("#DiagForm").empty();
	      cbg.combogrid("hidePanel");
	}
	

	//创建表达式控件
	function CreateExpDom(jq1,jq2,baseId){
		
		var target=$(jq1).find('td[field='+jq2+'] input')
		var targetf=$(jq1).find('td[field='+jq2+'F] input')
		var target1=$(jq1).find('td[field='+jq2+'] input:eq(1)')
		//detailstr[jq2]=targetf.val();
		
		target.change(function(){
			if(target.val()==""){
				targetf.val('')
			}
		})
		target.click(function(){
			var expValue=targetf.val() //表达式控件的值
			if(expValue=="")
			{
				//alert(target1.offset().top+"^"+target1.offset().left)
				var options = target.combogrid("grid").datagrid("options");		
				options.url = $URL+"?ClassName=web.DHCBL.MKB.MKBTermProDetail&MethodName=GetTermListForDoc&base="+baseId,
				options.onClickRow=function (rowIndex, rowData){
					var selected = cbg.combogrid('grid').datagrid('getSelected');  
					if (selected) { 
						//ClickDiagCombo(selected.MKBTRowId,selected.MKBTCode,selected.MKBTDesc,selected.comDesc)
						ClickDiagCombo(selected.MKBTRowId)
					}
					setTimeout(function(){
						SelMRCICDRowid=$("#SelMKBRowId").val()
				    	var indexTemplate=tkMakeServerCall("web.DHCBL.MKB.SDSStructDiagnos","GetPropertyIdByFlag",SelMRCICDRowid,"DT");
				    	//alert(SelMRCICDRowid+"^"+indexTemplate)
				    	CreatPropertyDom(target1,SelMRCICDRowid,"",indexTemplate);
			    	},10)
				}
			}
			else
			{
				
				SelMRCICDRowid=expValue.split("-")[0]; //诊断id
	        	$("#SelMKBRowId").val(SelMRCICDRowid);
		    	var indexTemplate=tkMakeServerCall("web.DHCBL.MKB.SDSStructDiagnos","GetPropertyIdByFlag",SelMRCICDRowid,"DT");
		    	//alert(SelMRCICDRowid+"^"+indexTemplate)
		    	CreatPropertyDom(target1,SelMRCICDRowid,expValue,indexTemplate);
			}
			//属性列表确定按钮功能
			$("#confirm_btn_Property").unbind('click').click(function(){
				var paramStr=GetParamStr("");
				targetf.val(paramStr)		
				var detail=tkMakeServerCall('web.DHCBL.MKB.MKBKLMappingDetail','GetExpDesc',paramStr)
				//target.val(detail)
				var ed=$("#mygrid").datagrid("getEditor",{index:editIndex,field:jq2});	
				$(ed.target).combogrid('setValue', detail)
				$("#mypropertylist").hide();	
			})
		});
	
	}
	//属性列表取消按钮功能
	$("#cancel_btn_Property").click(function (e) { 
		$("#mypropertylist").hide();	
	}) 
	
	//创建可编辑属性列表控件
	///target-触发位置，SelMRCICDRowid-诊断id，SDSRowId-id，indexTemplate-诊断模板id
	function CreatPropertyDom(target,SelMRCICDRowid,SDSRowId,indexTemplate){
			$('#Form_DiagPropertySearchGrid').datagrid('loadData',{total:0,rows:[]})
			$('#Form_DiagPropertySelectedGrid').datagrid('loadData',{total:0,rows:[]})
			$("#DiagForm").empty();
			SelPropertyData="";
			LoadPropertyData(SelMRCICDRowid,SDSRowId,indexTemplate);
			
			//再次打开时重新设置默认值，以防拖动后显示不下
			$("#mypropertylist").css("width",myProWidth+"px")
			$("#mypropertylist").css("height",myProHeight+"px")
			$('#mypromplayout').layout('panel', 'west').panel('resize',{width:myProWidth*(1/4)});
		    $('#mypromplayout').layout('panel', 'east').panel('resize',{width:myProWidth*(9/20)});
		    
			if(target.offset().top+$("#mypropertylist").height()+30>$(window).height()){
				//2019-10-15 chenying
				if((target.offset().top-$("#mypropertylist").height()-5)<0)
				{
					//偏移
					$("#mypropertylist").css({
						"top": target.offset().top-(target.offset().top+$("#mypropertylist").height()+30-$(window).height()),
						"left": target.offset().left
					}).show();
				}
				else
				{
					//显示在上面
					$("#mypropertylist").css({
							"top": target.offset().top-$("#mypropertylist").height()-5,
							"left": target.offset().left
						}).show();
						
				}
			}
			else{
				//显示在下面
				$("#mypropertylist").css({
					"top": target.offset().top+30,
					"left": target.offset().left
				}).show();
			}
			$("#mypropertylayout").layout("resize");
			
			//结构化诊断属性列表拖动改变大小
			 $('#mypropertylist').resizable({
			    onStopResize:function(e){
			    	$('#mypromplayout').layout('panel', 'west').panel('resize',{width:$("#mypropertylist").width()*(1/4)});
		            $('#mypromplayout').layout('panel', 'east').panel('resize',{width:$("#mypropertylist").width()*(9/20)});
		            $("#mypropertylayout").layout("resize");
			    }
			});
	}
    
	//创建表达式控件——可以选多个诊断
	/*function CreateExpDom(jq1,jq2,baseId){
		var target=$(jq1).find('td[field='+jq2+'] input')
		var targetf=$(jq1).find('td[field='+jq2+'F] input')
		
		detailstr[jq2]=targetf.val();
		//$('body').append(' <div id="baseiframe"><iframe id="upload" src="../csp/dhc.bdp.mkb.mkbknoexpression.csp'+'?base='+base+'?str='+str+' frameborder="0" width="100%" height="100%" scrolling="no"></iframe></div>')
		target.change(function(){
			if(target.val()==""){
				targetf.val('')
			}
		})
		target.click(function(){
			
			loadData(detailstr[jq2],baseId,jq2,$(this))
			if(target.offset().top+$("#knoExe").height()+35>$(window).height()){
				$("#knoExe").css({
					"top": target.offset().top-$("#knoExe").height()-25
				}).show();
			}
			else{
				$("#knoExe").css({
					"top": target.offset().top+30
				}).show();
			}
			if($(window).width()-target.offset().left<$("#knoExe").width()){
				$("#knoExe").css({
					"left": $(window).width()-$("#knoExe").width()
				}).show();

			}
			else{
				$("#knoExe").css({
					"left": target.offset().left
				}).show();
			}						
			$("#read_btn").unbind('click').click(function(){
				addBase(baseId,jq2)	
				$("#knoExe").unbind('hide').hide("normal",function(){
					targetf.val(detailstr[jq2])
					var detail=tkMakeServerCall('web.DHCBL.MKB.MKBKnoExpression','GetDiagDesc',detailstr[jq2])
					target.val(detail)
				})
			})
			$(".knowledgeclass").next().find("input").focus();
		});
		
		
	}*/
	
	//创建多行文本框
	function CreateTADom(jq1,jq2){   //生成textarea下拉区域
		
		var target=$(jq1).find('td[field='+jq2+'] textarea')
		target.click(function(){
			$('body').append('<textarea rows="10" cols="30" id="textareadom" style="z-index:999999;display:none;position:absolute;background:#FFFFFF">')
			$("#textareadom").val(target.val())
			if(target.offset().top+$("#textareadom").height()>$(window).height()){
				$("#textareadom").css({
                    "left": target.offset().left,
                    "top": target.offset().top-$("#textareadom").height()+27,
                    "width":target.width()
                }).show();
			}
			else{
				$("#textareadom").css({
                    "left": target.offset().left,
                    "top": target.offset().top,
                    "width":target.width()
                }).show();
			}
            $("#textareadom").focus(function(){
	        	//$('#knoExe').css('display','none'); 
            	$("#mypropertylist").hide();
	        }).focus().blur(function(){
                target.val($("#textareadom").val())	
				$(this).remove();
			}).keydown(function(e){
					if(e.keyCode==13){
						//$("#textareadom").hide();
						target.val($("#textareadom").val())	
					}
			}).click(stopPropagation);
		});
		
	}
	///***************************************统一的封装控件——表达式和多行文本框(结束)**************************************************/
	
	///**************************************************中间列表显示（结束）**************************************************************/
	
	///**************************************************配置检索窗口（开始）**************************************************************/
	var configcolumns =[[
		{ field: 'ck', checkbox: true, width: '30' },  //复选框  	
		{field:'MKBKMBFRowId',title:'RowId',width:100,hidden:true,sortable:true},
		{field:'MKBKMBFDesc',title:'配置检索列',width:100,sortable:false}
	]];
	
	$("#searchConfig").popover({
    	content:'<div style="height:180px;width:300px;" ><table data-options="fit:true"  id="configgrid" ></table></div>',
    	onShow:function(e,value){
	    		InitConfigGrid();
	    },
	    trigger:'hover',
	    onHide:function(e,value){
			var rows = $('#configgrid').datagrid('getSelections');
			searchConfigs=""
			unsearchConfigs=""
			//已选检索列
			for(var i=0; i<rows.length; i++){
				if (searchConfigs!="")
				{
					searchConfigs=searchConfigs+"^"+rows[i].MKBKMBFRowId
				}
				else
				{
					searchConfigs=rows[i].MKBKMBFRowId
				}
			}
			//未选检索列
			var allrows = $('#configgrid').datagrid('getRows');
			var searchStr="^"+searchConfigs+"^"
			for(var i=0; i<allrows.length; i++){
				var idStr="^"+allrows[i].MKBKMBFRowId+"^"
				if(searchStr.indexOf(idStr)==-1)
				{
					if (unsearchConfigs!="")
					{
						unsearchConfigs=unsearchConfigs+"^"+allrows[i].MKBKMBFRowId
					}
					else
					{
						unsearchConfigs=allrows[i].MKBKMBFRowId
					}
				}
			}
	    }
    });	
		 
	//生成配置列表
	InitConfigGrid=function ()
	{
		var configgrid = $HUI.datagrid("#configgrid",{
			bodyCls:'panel-header-gray',
			url:$URL,
			queryParams:{
				ClassName:"web.DHCBL.MKB.MKBKLMappingBaseField",
				QueryName:"GetList",
				base:base,
				rows:1000
			},
			width:'100%',
			height:'100%',
			autoRowHeight: true,
			columns: configcolumns,  //列信息
			pagination: false,   //pagination   boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
			singleSelect:false,
			remoteSort:false,
			idField:'MKBKMBFRowId',
			//rownumbers:true,    //设置为 true，则显示带有行号的列。
			fitColumns:true,//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
			scrollbarSize :0,
			onClickRow:function(rowIndex,rowData){
			},
			onRowContextMenu:function (e, rowIndex,row) { //右键时触发事件
			}
			
		});
	}	
	///**************************************************配置检索窗口（结束）**************************************************************/
}
$(init);

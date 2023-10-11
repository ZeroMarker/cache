
var extraAttr = "KnowType";			// 知识类型(附加属性)
var extraAttrValue = "ModelFlag" 	// 实体标记(附加属性值)
var cat = "";						// 药学分类
var comname = "";					// 通用名
var component = "";					// 成分
var comnameDos = "";				// 带剂型的通用名
var drugId = "";					// 药品名称
/// 页面初始化函数
function initPageDefault(){
	InitDrugCat();			//分类
	InitComname();			//通用名
	InitComponent();		//成分
	InitComnameDos();		//通用名(带剂型)
	InitDrugList();			//初始化药品列表
	InitAttrList();			//初始化属性列表
	InitTabs();				//初始化tabs
}

///初始化药学分类
function InitDrugCat()
{
	var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonDataByNode&id="+106+"&Input=";
	var option = {
		height:$(window).height()-105,   ///需要设置高度，不然数据展开太多时，列头就滚动上去了。
		multiple: true,
		lines:true,
		checkbox:true,
		checkOnSelect : true,
		cascadeCheck:false,  		//是否级联检查。默认true  菜单特殊，不级联操作
		fitColumns:true,
		animate:true,
        onClick:function(node, checked){
	        
	        cat = node.id;			//记录
	        
	        var isLeaf = $("#drugcat").tree('isLeaf',node.target);   /// 是否是叶子节点
	        if (isLeaf){
		        						   
	        }else{
		    	//$("#attrtree").tree('toggle',node.target);   /// 点击项目时,直接展开/关闭
		    }
		    //QueryAtrrList();
	    },
	    onCheck:function(node,checked)
	    {
		    $(this).tree('select', node.target);
		},
	    onContextMenu: function(e, node){
			
			e.preventDefault();
			$(this).tree('select', node.target);
			var node = $("#dictree").tree('getSelected');
			if (node == null){
				$.messager.alert("提示","请选中节点后重试!"); 
				return;
			}
				
			// 显示快捷菜单
			$('#right').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		},
	    onExpand:function(node, checked){
			var childNode = $("#drugcat").tree('getChildren',node.target)[0];  /// 当前节点的子节点
			
	        var isLeaf = $("#drugcat").tree('isLeaf',childNode.target);        /// 是否是叶子节点
	        if (isLeaf){
	        }
		}
	};
	new CusTreeUX("drugcat", url, option).Init();
}

///初始化通用名
function InitComname()
{
	// 编辑格
	var texteditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	// 定义columns   
	var columns=[[   	 
			{field:'dicId',title:'dicId',hidden:true},
			{field:'dicCode',title:'代码',width:300,align:'left',editor:texteditor,formatter:tomodify,hidden:true},		//
			{field:'dicDesc',title:'通用名',width:300,align:'left',editor:texteditor},		//,formatter:tomodify
			{field:'parref',title:'父节点id',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'linkDr',title:'linkDr',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'linkDesc',title:'关联描述',width:300,align:'left',editor:texteditor,hidden:true}
		 ]]

	var option={	
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],
		data:{
				"total":3,
				"rows":[
					{"dicId":"85329","dicCode":"丙戊酸","dicDesc":"丙戊酸","parref":"","linkDr":"","linkDesc":""},
					{"dicId":"69237","dicCode":"09","dicDesc":"丙戊酰胺","parref":"","linkDr":"","linkDesc":""},
					{"dicId":"69241","dicCode":"15","dicDesc":"氨己烯酸","parref":"","linkDr":"","linkDesc":""}
				]
		},		
 		onClickRow:function(rowIndex,rowData){
	 		
	 		comname = rowData.dicId;		//通用名
	 		
	 		InitAttrList(comAttrData);
	 		
	 	}, 
		onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (editsubRow != ""||editsubRow == 0) { 
                $("#drugcomname").datagrid('endEdit', editsubRow); 
            } 
            $("#drugcomname").datagrid('beginEdit', rowIndex); 
            
            editsubRow = rowIndex; 
        },
        onLoadSuccess:function(data){
              
        }	
		  
	}

	var uniturl = ""  //$URL+"?ClassName=web.DHCCKBDrugAttrRegLev&MethodName=QueryComnameAttr&catId="+cat;
	new ListComponent('drugcomname', columns, uniturl, option).Init();
	
}

///成分
function InitComponent()
{
	// 编辑格
	var texteditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	// 定义columns   
	var columns=[[   	 
			{field:'dicId',title:'dicId',hidden:true},
			{field:'dicCode',title:'代码',width:300,align:'left',editor:texteditor,formatter:tomodify,hidden:true},		//
			{field:'dicDesc',title:'成分',width:300,align:'left',editor:texteditor},		//,formatter:tomodify
			{field:'parref',title:'父节点id',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'linkDr',title:'linkDr',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'linkDesc',title:'关联描述',width:300,align:'left',editor:texteditor,hidden:true}
		 ]]

	var option={	
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],
		data:{
				"total":2,
				"rows":[
					{"dicId":"5533","dicCode":"丙戊酸钠","dicDesc":"丙戊酸钠","parref":"","linkDr":"","linkDesc":""},
					{"dicId":"23032","dicCode":"丙戊酸镁","dicDesc":"丙戊酸镁","parref":"","linkDr":"","linkDesc":""}
				]
			},		
 		onClickRow:function(rowIndex,rowData){
	 		component = rowData.dicId;		//成分
	 		InitAttrList(compentAttrData);
	 		
	 	}, 
		onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (editsubRow != ""||editsubRow == 0) { 
                $("#drugcomp").datagrid('endEdit', editsubRow); 
            } 
            $("#drugcomp").datagrid('beginEdit', rowIndex); 
            
            editsubRow = rowIndex; 
        },
        onLoadSuccess:function(data){
              
        }	
		  
	}
	var uniturl = ""  //$URL+"?ClassName=web.DHCCKBDrugAttrRegLev&MethodName=QueryCompentAttr";
	new ListComponent('drugcomp', columns, uniturl, option).Init();
}

//带剂型的通用名
function InitComnameDos()
{
	// 编辑格
	var texteditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	// 定义columns   
	var columns=[[   	 
			{field:'dicId',title:'dicId',hidden:true},
			{field:'dicCode',title:'代码',width:300,align:'left',editor:texteditor,formatter:tomodify,hidden:true},		//
			{field:'dicDesc',title:'通用名(带剂型)',width:300,align:'left',editor:texteditor},		//,formatter:tomodify
			{field:'parref',title:'父节点id',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'linkDr',title:'linkDr',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'linkDesc',title:'关联描述',width:300,align:'left',editor:texteditor,hidden:true}
		 ]]

	var option={	
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],		
 		onClickRow:function(rowIndex,rowData){
	 		comnameDos = rowData.dicId;	//带剂型通用名
	 		InitAttrList(comdosAttrData);
	 	}, 
		onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (editsubRow != ""||editsubRow == 0) { 
                $("#drugcomdos").datagrid('endEdit', editsubRow); 
            } 
            $("#drugcomdos").datagrid('beginEdit', rowIndex); 
            
            editsubRow = rowIndex; 
        },
        onLoadSuccess:function(data){
              
        }	
		  
	}
	var uniturl = $URL+"?ClassName=web.DHCCKBDrugAttrRegLev&MethodName=QueryComDosAttr";
	new ListComponent('drugcomdos', columns, uniturl, option).Init();
}

///初始化药品列表
function InitDrugList()
{
	// 编辑格
	var texteditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	// 定义columns   
	var columns=[[   	 
			{field:'dicId',title:'dicId',hidden:true},
			{field:'dicCode',title:'代码',width:300,align:'left',editor:texteditor,formatter:tomodify,hidden:true},		//
			{field:'dicDesc',title:'药品名称',width:300,align:'left',editor:texteditor},		//,formatter:tomodify
			{field:'parref',title:'父节点id',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'linkDr',title:'linkDr',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'linkDesc',title:'关联描述',width:300,align:'left',editor:texteditor,hidden:true}
		 ]]

	var option={	
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],		
 		onClickRow:function(rowIndex,rowData){
	 		drugId = rowData.dicId;	//带剂型通用名
	 		QueryAtrrList();
	 	}, 
		onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (editsubRow != ""||editsubRow == 0) { 
                $("#druglist").datagrid('endEdit', editsubRow); 
            } 
            $("#druglist").datagrid('beginEdit', rowIndex); 
            
            editsubRow = rowIndex; 
        },
        onLoadSuccess:function(data){
              
        }	
		  
	}
	var uniturl = $URL+"?ClassName=web.DHCCKBDrugAttrRegLev&MethodName=QueryDrugList";
	new ListComponent('druglist', columns, uniturl, option).Init();
}
///处理特殊字符
function tomodify(value, rowData, rowIndex)
{
	//var value=value.replace("′","^")   //替换为搜狗，特殊符号，数学符号里的 "′";
	return value;
	var dgvalue=rowData.CDCode;
	return dgvalue.replace('′',"^")  ;
}

///初始化属性列表
function InitAttrList(tabdata)
{
	// 定义columns	
	var columns=[[   
			{field:'attrID',title:'属性id',width:60,align:'left',hidden:true},
			{field:'attrCode',title:'属性代码',width:180,align:'left',hidden:true},
			{field:'attrDesc',title:'属性',width:180,align:'left'},
			{field:'dataType',title:'数据类型',width:80,align:'left',hidden:true},
			{field:'AttrValue',title:'属性值',width:310,align:'left',hidden:false},
			{field:'Operating',title:'操作',width:50,align:'center',hidden:true}
		 ]]

	var option={	
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],
		data:tabdata,		
 		onClickRow:function(rowIndex,rowData){   
 			
		}, 	
		onDblClickRow:function(rowIndex,rowData){  
 			
		}, 		
		onLoadSuccess:function(data){      
          $('.mytooltip').tooltip({
            trackMouse:true,
            onShow:function(e){
              $(this).tooltip('tip').css({});
            }
          });          
        }
		  
	}
	var params = "";
	var uniturl = "" //$URL+"?ClassName=web.DHCCKBEditProp&MethodName=GetAttrListData&params="+params;

	new ListComponent('attrList', columns, uniturl, option).Init();
}


/// 属性列表
function QueryAtrrList(){

	var params = ""+"^"+drugId;

	var options={}
	options.url=$URL+"?ClassName=web.DHCCKBEditProp&MethodName=GetAttrListData&params="+params;

	$('#attrList').datagrid(options);
	$('#attrList').datagrid('reload');
}
///初始化tabs
function InitTabs()
{
	/// tabs 选项卡
	$("#tabs").tabs({
		onSelect:function(title){
		   if(title=="通用名"){
			   //reloadComname();
		   }else if(title=="成分"){
			  // reloadCompent();
		   }else if(title=="通用名(带剂型)"){
			   reloadComDos();
		   }else if(title=="药品"){
			   reloadDrugList();
		   }
		}
	});
}
///加载通用名
function reloadComname()
{
	var unitUrl = $URL+"?ClassName=web.DHCCKBDrugAttrRegLev&MethodName=QueryComnameAttr";
	$('#drugcomname').datagrid('load',{'catId':cat});
}
///加载成分
function reloadCompent()
{
	var unitUrl = $URL+"?ClassName=web.DHCCKBDrugAttrRegLev&MethodName=QueryCompentAttr";
	$('#drugcomp').datagrid('load',{'catId':cat,"comnameId":comname});
}
///加载带剂型的通用名
function reloadComDos()
{
	var unitUrl = $URL+"?ClassName=web.DHCCKBDrugAttrRegLev&MethodName=QueryComDosAttr";
	$('#drugcomdos').datagrid('load',{'catId':cat,"comnameId":comname,"component":component});
}
///加载药品
function reloadDrugList()
{
	var unitUrl = $URL+"?ClassName=web.DHCCKBDrugAttrRegLev&MethodName=QueryDrugList";
	$('#druglist').datagrid('load',{'catId':cat,"comnameId":comname,"component":component,"comnameDos":comnameDos});
}

///通用名数据			
var comAttrData = [
	{"attrID":"94752","attrCode":"哺乳期分级","attrDesc":"哺乳期分级","dataType":"","AttrValue":"","Operating":""},
	{"attrID":"8146","attrCode":"FDA妊娠药物分级","attrDesc":"FDA妊娠药物分级","dataType":"","AttrValue":"D","Operating":""},
	{"attrID":"41","attrCode":"EngName","attrDesc":"英文名称","dataType":"","AttrValue":"Depakine ( Epilim )（Sodium Valproate Sustained-release Tablets）","Operating":""},
	{"attrID":"78004","attrCode":"药理毒理","attrDesc":"药理毒理","dataType":"","AttrValue":"本品为抗癫痫药。其作用机理尚未完全阐明。实验见本品能增加GABA的合成和减少GABA的降解，从而升高抑制性神经递质γ-氨基丁酸（GABA）的浓度，降低神经元的兴奋性而抑制发作。在电生理实验中见本品可产生与苯妥英相似的抑制Na+通道的作用。对肝脏有损害。","Operating":""},
	{"attrID":"77981","attrCode":"药理作用","attrDesc":"药理作用","dataType":"","AttrValue":"","Operating":""}
]

///成分数据
var compentAttrData = []

///带剂型的通用名
var comdosAttrData = [
	{"attrID":"4009","attrCode":"警告","attrDesc":"警告","dataType":"","AttrValue":"有肝病或明显肝功能损害时禁用。","Operating":""},
	{"attrID":"41","attrCode":"EngName","attrDesc":"英文名称","dataType":"","AttrValue":"Depakine ( Epilim )（Sodium Valproate Sustained-release Tablets）","Operating":""},
	{"attrID":"78005","attrCode":"汉语拼音","attrDesc":"汉语拼音","dataType":"","AttrValue":"Bing Wu Suan Na Huan Shi Pian","Operating":""},
	{"attrID":"78010","attrCode":"药物过量","attrDesc":"药物过量","dataType":"","AttrValue":"当急性超大剂量服药时，通常出现的症状包括伴有肌张力低下的昏迷、反射低下、瞳孔缩小、呼吸功能障碍、代谢性酸中毒。临床症状可以多变，有报道说血药浓度过高时会出现癫痫发作与脑水肿有关的颅内高压病例也曾报道过。对过量服药的处理应根据症状：洗胃治疗在药物摄入后10-12小时内有效，保持尿液分泌、心肺监测。在非常严重的情况下，如必要可采用血液透析进行处治。有报道纳洛酮可以逆转丙戊酸钠用药过量导致的中枢神经系统抑制效应。由于在理论上纳洛酮也对双丙戊酸钠的抗癫痫效应有所逆转，所以在癫痫患者中应用纳洛酮时应该多加注意。通常情况下预后较好。但有零散的死亡病例报道。","Operating":""},
	{"attrID":"81577","attrCode":"OTCProp","attrDesc":"临床试验","dataType":"","AttrValue":"","Operating":""},
	{"attrID":"78011","attrCode":"药代动力学","attrDesc":"药是否OTC","dataType":"","AttrValue":"","Operating":""},
	{"attrID":"14424","attrCode":"临床试验","attrDesc":"代动力学","dataType":"","AttrValue":"进行了多项丙戊酸盐的药代动力学研究，结果显示： 采用血药浓度作为指标的考察结果显示，口服药物的生物利用度接近100%。 大部分药物在血液中分布，并存在与细胞外液的快速交换过程。同时药物也可在脑脊液 (CSF) 和大脑总分布。CSF中丙戊酸盐的浓度与血浆中游离药物浓度接近。 药物的半衰期为15-17小时。儿童通常更短。 产生治疗作用的血清药物浓度低限通常为40-50mg/L，范围可放宽至40-100mg/L。如果确认有必要使血药浓度更高，必须在产生的疗效与可能产生的副反应之间进行权衡。尤其是那些与血药浓度相关的副反应。但是，如果血药浓度水平一直维持在150mg/L之上，则需要减低剂量。 连续服药3-4天后药物的血药浓度达到稳态。 丙戊酸盐在体内通过葡萄糖醛酸化和β-氯化等转化后通过尿液排泄。 丙戊酸盐可被透析出来，但血液透析仅影响游离药物的血药浓度 (约占血药浓度的10%) 。丙戊酸盐对CYP450代谢系统所涉及的酶不产生诱导作用。与多数其它的抗癫痫药物相比，其不会使自身和其它药物的降解速度加快，如雌激素-孕激素和口服抗凝药物。与丙戊酸盐的肠溶制剂相比较，相同剂量下服用本品后药物的体内药代动力学情况具有如下特点： 没有吸收延迟相： 吸收相延长： 生物利用度相同； 总血药浓度及游离血药浓度的峰值降低( Cmax约降低25%，且在服药后4-14小时之间呈现相对稳定的平台期) ：在24小时期间丙戊酸的血药浓度-时间曲线呈现“平滑峰”的现象，丙戊酸的血药浓度较稳定且持续24小时：一天两次口服相同剂量后，丙戊酸盐血药浓度的变化幅度降低一半。 总血药浓度及游离血药浓度与给药剂量之间的线性关系更为良好。","Operating":""},
	{"attrID":"40","attrCode":"FormProp","attrDesc":"剂型","dataType":"","AttrValue":"片剂","Operating":""},
	{"attrID":"7879","attrCode":"Taboo","attrDesc":"配伍禁忌","dataType":"","AttrValue":"","Operating":""},
	{"attrID":"106661","attrCode":"SpeCatProp","attrDesc":"专科分类","dataType":"","AttrValue":"","Operating":""},
	{"attrID":"110581","attrCode":"SkinTestDrugProp","attrDesc":"皮试药品","dataType":"","AttrValue":"","Operating":""},
	{"attrID":"111062","attrCode":"HighDangerFlag","attrDesc":"高危药品标志","dataType":"","AttrValue":"","Operating":""},
	{"attrID":"111255","attrCode":"EssDrugProp","attrDesc":"国家基本药物","dataType":"","AttrValue":"","Operating":""},
	{"attrID":"111631","attrCode":"AdjDrugProp","attrDesc":"辅助用药属性","dataType":"","AttrValue":"","Operating":""}
]

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
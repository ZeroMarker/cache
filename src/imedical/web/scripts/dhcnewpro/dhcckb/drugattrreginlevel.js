
var extraAttr = "KnowType";			// ֪ʶ����(��������)
var extraAttrValue = "ModelFlag" 	// ʵ����(��������ֵ)
var cat = "";						// ҩѧ����
var comname = "";					// ͨ����
var component = "";					// �ɷ�
var comnameDos = "";				// �����͵�ͨ����
var drugId = "";					// ҩƷ����
/// ҳ���ʼ������
function initPageDefault(){
	InitDrugCat();			//����
	InitComname();			//ͨ����
	InitComponent();		//�ɷ�
	InitComnameDos();		//ͨ����(������)
	InitDrugList();			//��ʼ��ҩƷ�б�
	InitAttrList();			//��ʼ�������б�
	InitTabs();				//��ʼ��tabs
}

///��ʼ��ҩѧ����
function InitDrugCat()
{
	var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonDataByNode&id="+106+"&Input=";
	var option = {
		height:$(window).height()-105,   ///��Ҫ���ø߶ȣ���Ȼ����չ��̫��ʱ����ͷ�͹�����ȥ�ˡ�
		multiple: true,
		lines:true,
		checkbox:true,
		checkOnSelect : true,
		cascadeCheck:false,  		//�Ƿ�����顣Ĭ��true  �˵����⣬����������
		fitColumns:true,
		animate:true,
        onClick:function(node, checked){
	        
	        cat = node.id;			//��¼
	        
	        var isLeaf = $("#drugcat").tree('isLeaf',node.target);   /// �Ƿ���Ҷ�ӽڵ�
	        if (isLeaf){
		        						   
	        }else{
		    	//$("#attrtree").tree('toggle',node.target);   /// �����Ŀʱ,ֱ��չ��/�ر�
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
				$.messager.alert("��ʾ","��ѡ�нڵ������!"); 
				return;
			}
				
			// ��ʾ��ݲ˵�
			$('#right').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		},
	    onExpand:function(node, checked){
			var childNode = $("#drugcat").tree('getChildren',node.target)[0];  /// ��ǰ�ڵ���ӽڵ�
			
	        var isLeaf = $("#drugcat").tree('isLeaf',childNode.target);        /// �Ƿ���Ҷ�ӽڵ�
	        if (isLeaf){
	        }
		}
	};
	new CusTreeUX("drugcat", url, option).Init();
}

///��ʼ��ͨ����
function InitComname()
{
	// �༭��
	var texteditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	// ����columns   
	var columns=[[   	 
			{field:'dicId',title:'dicId',hidden:true},
			{field:'dicCode',title:'����',width:300,align:'left',editor:texteditor,formatter:tomodify,hidden:true},		//
			{field:'dicDesc',title:'ͨ����',width:300,align:'left',editor:texteditor},		//,formatter:tomodify
			{field:'parref',title:'���ڵ�id',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'linkDr',title:'linkDr',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'linkDesc',title:'��������',width:300,align:'left',editor:texteditor,hidden:true}
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
					{"dicId":"85329","dicCode":"������","dicDesc":"������","parref":"","linkDr":"","linkDesc":""},
					{"dicId":"69237","dicCode":"09","dicDesc":"��������","parref":"","linkDr":"","linkDesc":""},
					{"dicId":"69241","dicCode":"15","dicDesc":"����ϩ��","parref":"","linkDr":"","linkDesc":""}
				]
		},		
 		onClickRow:function(rowIndex,rowData){
	 		
	 		comname = rowData.dicId;		//ͨ����
	 		
	 		InitAttrList(comAttrData);
	 		
	 	}, 
		onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
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

///�ɷ�
function InitComponent()
{
	// �༭��
	var texteditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	// ����columns   
	var columns=[[   	 
			{field:'dicId',title:'dicId',hidden:true},
			{field:'dicCode',title:'����',width:300,align:'left',editor:texteditor,formatter:tomodify,hidden:true},		//
			{field:'dicDesc',title:'�ɷ�',width:300,align:'left',editor:texteditor},		//,formatter:tomodify
			{field:'parref',title:'���ڵ�id',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'linkDr',title:'linkDr',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'linkDesc',title:'��������',width:300,align:'left',editor:texteditor,hidden:true}
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
					{"dicId":"5533","dicCode":"��������","dicDesc":"��������","parref":"","linkDr":"","linkDesc":""},
					{"dicId":"23032","dicCode":"������þ","dicDesc":"������þ","parref":"","linkDr":"","linkDesc":""}
				]
			},		
 		onClickRow:function(rowIndex,rowData){
	 		component = rowData.dicId;		//�ɷ�
	 		InitAttrList(compentAttrData);
	 		
	 	}, 
		onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
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

//�����͵�ͨ����
function InitComnameDos()
{
	// �༭��
	var texteditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	// ����columns   
	var columns=[[   	 
			{field:'dicId',title:'dicId',hidden:true},
			{field:'dicCode',title:'����',width:300,align:'left',editor:texteditor,formatter:tomodify,hidden:true},		//
			{field:'dicDesc',title:'ͨ����(������)',width:300,align:'left',editor:texteditor},		//,formatter:tomodify
			{field:'parref',title:'���ڵ�id',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'linkDr',title:'linkDr',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'linkDesc',title:'��������',width:300,align:'left',editor:texteditor,hidden:true}
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
	 		comnameDos = rowData.dicId;	//������ͨ����
	 		InitAttrList(comdosAttrData);
	 	}, 
		onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
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

///��ʼ��ҩƷ�б�
function InitDrugList()
{
	// �༭��
	var texteditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	// ����columns   
	var columns=[[   	 
			{field:'dicId',title:'dicId',hidden:true},
			{field:'dicCode',title:'����',width:300,align:'left',editor:texteditor,formatter:tomodify,hidden:true},		//
			{field:'dicDesc',title:'ҩƷ����',width:300,align:'left',editor:texteditor},		//,formatter:tomodify
			{field:'parref',title:'���ڵ�id',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'linkDr',title:'linkDr',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'linkDesc',title:'��������',width:300,align:'left',editor:texteditor,hidden:true}
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
	 		drugId = rowData.dicId;	//������ͨ����
	 		QueryAtrrList();
	 	}, 
		onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
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
///���������ַ�
function tomodify(value, rowData, rowIndex)
{
	//var value=value.replace("��","^")   //�滻Ϊ�ѹ���������ţ���ѧ������� "��";
	return value;
	var dgvalue=rowData.CDCode;
	return dgvalue.replace('��',"^")  ;
}

///��ʼ�������б�
function InitAttrList(tabdata)
{
	// ����columns	
	var columns=[[   
			{field:'attrID',title:'����id',width:60,align:'left',hidden:true},
			{field:'attrCode',title:'���Դ���',width:180,align:'left',hidden:true},
			{field:'attrDesc',title:'����',width:180,align:'left'},
			{field:'dataType',title:'��������',width:80,align:'left',hidden:true},
			{field:'AttrValue',title:'����ֵ',width:310,align:'left',hidden:false},
			{field:'Operating',title:'����',width:50,align:'center',hidden:true}
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


/// �����б�
function QueryAtrrList(){

	var params = ""+"^"+drugId;

	var options={}
	options.url=$URL+"?ClassName=web.DHCCKBEditProp&MethodName=GetAttrListData&params="+params;

	$('#attrList').datagrid(options);
	$('#attrList').datagrid('reload');
}
///��ʼ��tabs
function InitTabs()
{
	/// tabs ѡ�
	$("#tabs").tabs({
		onSelect:function(title){
		   if(title=="ͨ����"){
			   //reloadComname();
		   }else if(title=="�ɷ�"){
			  // reloadCompent();
		   }else if(title=="ͨ����(������)"){
			   reloadComDos();
		   }else if(title=="ҩƷ"){
			   reloadDrugList();
		   }
		}
	});
}
///����ͨ����
function reloadComname()
{
	var unitUrl = $URL+"?ClassName=web.DHCCKBDrugAttrRegLev&MethodName=QueryComnameAttr";
	$('#drugcomname').datagrid('load',{'catId':cat});
}
///���سɷ�
function reloadCompent()
{
	var unitUrl = $URL+"?ClassName=web.DHCCKBDrugAttrRegLev&MethodName=QueryCompentAttr";
	$('#drugcomp').datagrid('load',{'catId':cat,"comnameId":comname});
}
///���ش����͵�ͨ����
function reloadComDos()
{
	var unitUrl = $URL+"?ClassName=web.DHCCKBDrugAttrRegLev&MethodName=QueryComDosAttr";
	$('#drugcomdos').datagrid('load',{'catId':cat,"comnameId":comname,"component":component});
}
///����ҩƷ
function reloadDrugList()
{
	var unitUrl = $URL+"?ClassName=web.DHCCKBDrugAttrRegLev&MethodName=QueryDrugList";
	$('#druglist').datagrid('load',{'catId':cat,"comnameId":comname,"component":component,"comnameDos":comnameDos});
}

///ͨ��������			
var comAttrData = [
	{"attrID":"94752","attrCode":"�����ڷּ�","attrDesc":"�����ڷּ�","dataType":"","AttrValue":"","Operating":""},
	{"attrID":"8146","attrCode":"FDA����ҩ��ּ�","attrDesc":"FDA����ҩ��ּ�","dataType":"","AttrValue":"D","Operating":""},
	{"attrID":"41","attrCode":"EngName","attrDesc":"Ӣ������","dataType":"","AttrValue":"Depakine ( Epilim )��Sodium Valproate Sustained-release Tablets��","Operating":""},
	{"attrID":"78004","attrCode":"ҩ����","attrDesc":"ҩ����","dataType":"","AttrValue":"��ƷΪ�����ҩ�������û�����δ��ȫ������ʵ�����Ʒ������GABA�ĺϳɺͼ���GABA�Ľ��⣬�Ӷ������������񾭵��ʦ�-�������ᣨGABA����Ũ�ȣ�������Ԫ���˷��Զ����Ʒ������ڵ�����ʵ���м���Ʒ�ɲ����뱽��Ӣ���Ƶ�����Na+ͨ�������á��Ը������𺦡�","Operating":""},
	{"attrID":"77981","attrCode":"ҩ������","attrDesc":"ҩ������","dataType":"","AttrValue":"","Operating":""}
]

///�ɷ�����
var compentAttrData = []

///�����͵�ͨ����
var comdosAttrData = [
	{"attrID":"4009","attrCode":"����","attrDesc":"����","dataType":"","AttrValue":"�иβ������Ըι�����ʱ���á�","Operating":""},
	{"attrID":"41","attrCode":"EngName","attrDesc":"Ӣ������","dataType":"","AttrValue":"Depakine ( Epilim )��Sodium Valproate Sustained-release Tablets��","Operating":""},
	{"attrID":"78005","attrCode":"����ƴ��","attrDesc":"����ƴ��","dataType":"","AttrValue":"Bing Wu Suan Na Huan Shi Pian","Operating":""},
	{"attrID":"78010","attrCode":"ҩ�����","attrDesc":"ҩ�����","dataType":"","AttrValue":"�����Գ��������ҩʱ��ͨ�����ֵ�֢״�������м��������µĻ��ԡ�������¡�ͫ����С�����������ϰ�����л�����ж����ٴ�֢״���Զ�䣬�б���˵ѪҩŨ�ȹ���ʱ�������﷢������ˮ���йص�­�ڸ�ѹ����Ҳ�����������Թ�����ҩ�Ĵ���Ӧ����֢״��ϴθ������ҩ�������10-12Сʱ����Ч��������Һ���ڡ��ķμ�⡣�ڷǳ����ص�����£����Ҫ�ɲ���ѪҺ͸�����д��Ρ��б�������ͪ������ת����������ҩ�������µ�������ϵͳ����ЧӦ������������������ͪҲ��˫�������ƵĿ����ЧӦ������ת����������ﻼ����Ӧ������ͪʱӦ�ö��ע�⡣ͨ�������Ԥ��Ϻá�������ɢ����������������","Operating":""},
	{"attrID":"81577","attrCode":"OTCProp","attrDesc":"�ٴ�����","dataType":"","AttrValue":"","Operating":""},
	{"attrID":"78011","attrCode":"ҩ������ѧ","attrDesc":"ҩ�Ƿ�OTC","dataType":"","AttrValue":"","Operating":""},
	{"attrID":"14424","attrCode":"�ٴ�����","attrDesc":"������ѧ","dataType":"","AttrValue":"�����˶���������ε�ҩ������ѧ�о��������ʾ�� ����ѪҩŨ����Ϊָ��Ŀ�������ʾ���ڷ�ҩ����������öȽӽ�100%�� �󲿷�ҩ����ѪҺ�зֲ�����������ϸ����Һ�Ŀ��ٽ������̡�ͬʱҩ��Ҳ�����Լ�Һ (CSF) �ʹ����ֲܷ���CSF�б������ε�Ũ����Ѫ��������ҩ��Ũ�Ƚӽ��� ҩ��İ�˥��Ϊ15-17Сʱ����ͯͨ�����̡� �����������õ�Ѫ��ҩ��Ũ�ȵ���ͨ��Ϊ40-50mg/L����Χ�ɷſ���40-100mg/L�����ȷ���б�ҪʹѪҩŨ�ȸ��ߣ������ڲ�������Ч����ܲ����ĸ���Ӧ֮�����Ȩ�⡣��������Щ��ѪҩŨ����صĸ���Ӧ�����ǣ����ѪҩŨ��ˮƽһֱά����150mg/L֮�ϣ�����Ҫ���ͼ����� ������ҩ3-4���ҩ���ѪҩŨ�ȴﵽ��̬�� ��������������ͨ��������ȩ�ữ�ͦ�-�Ȼ���ת����ͨ����Һ��й�� �������οɱ�͸����������ѪҺ͸����Ӱ������ҩ���ѪҩŨ�� (ԼռѪҩŨ�ȵ�10%) ���������ζ�CYP450��лϵͳ���漰��ø�������յ����á�����������Ŀ����ҩ����ȣ��䲻��ʹ���������ҩ��Ľ����ٶȼӿ죬��Ƽ���-�м��غͿڷ�����ҩ���������εĳ����Ƽ���Ƚϣ���ͬ�����·��ñ�Ʒ��ҩ�������ҩ������ѧ������������ص㣺 û�������ӳ��ࣺ �������ӳ��� �������ö���ͬ�� ��ѪҩŨ�ȼ�����ѪҩŨ�ȵķ�ֵ����( CmaxԼ����25%�����ڷ�ҩ��4-14Сʱ֮���������ȶ���ƽ̨��) ����24Сʱ�ڼ�������ѪҩŨ��-ʱ�����߳��֡�ƽ���塱�����󣬱������ѪҩŨ�Ƚ��ȶ��ҳ���24Сʱ��һ�����οڷ���ͬ�����󣬱�������ѪҩŨ�ȵı仯���Ƚ���һ�롣 ��ѪҩŨ�ȼ�����ѪҩŨ�����ҩ����֮������Թ�ϵ��Ϊ���á�","Operating":""},
	{"attrID":"40","attrCode":"FormProp","attrDesc":"����","dataType":"","AttrValue":"Ƭ��","Operating":""},
	{"attrID":"7879","attrCode":"Taboo","attrDesc":"�������","dataType":"","AttrValue":"","Operating":""},
	{"attrID":"106661","attrCode":"SpeCatProp","attrDesc":"ר�Ʒ���","dataType":"","AttrValue":"","Operating":""},
	{"attrID":"110581","attrCode":"SkinTestDrugProp","attrDesc":"Ƥ��ҩƷ","dataType":"","AttrValue":"","Operating":""},
	{"attrID":"111062","attrCode":"HighDangerFlag","attrDesc":"��ΣҩƷ��־","dataType":"","AttrValue":"","Operating":""},
	{"attrID":"111255","attrCode":"EssDrugProp","attrDesc":"���һ���ҩ��","dataType":"","AttrValue":"","Operating":""},
	{"attrID":"111631","attrCode":"AdjDrugProp","attrDesc":"������ҩ����","dataType":"","AttrValue":"","Operating":""}
]

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
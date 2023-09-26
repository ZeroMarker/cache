/**
 * �����쳣����ԭ�����JS
 * FileName:scripts/hisui/insutarpageconf.js
 * Huang SF 2018-03-16
 * �汾��V1.0
 * hisui�汾:0.1.0
 */
 
 //ȫ�ֱ���
 var accIdArr=[];
 var fieldSorTemp="";
 var fieldHidTemp="";
 
 //�������
$(function(){
	initData();
	initPanel();
	loadDataGridFun();
	loadChangeLoc();
});

function initData(){
	accIdArr[0]="colWidth";
	accIdArr[1]="colLocation";
	accIdArr[2]="colSort";
	accIdArr[3]="colHidden";
	
	
}
function initPanel(){
	loadData("colWidth");
	loadData("colSort");
	loadData("colHidden");
	
	$HUI.accordion("#accId",{
		onSelect:function(title,index){
			//alert("title:"+title+",index:"+index);
			//�첽����
			$.cm({
				ClassName:"web.INSUTarContrastCom",
				QueryName:"DhcTarQuery",
				sKeyWord:"�������Ȼ���ע��Һ",
				Class:"3",
				Type:"BJ",
				ConType:"Y",
				TarCate:"1",
				ActDate:"",
				ExpStr:""
			},function(jsonData){
				if(index!=1){
					$HUI.datagrid('#'+accIdArr[index]).loadData(jsonData);
				}
			});
		}
	});
}

function loadData(id){
	//��ʼ�����յ�grid
	$HUI.datagrid("#"+id,{
		rownumbers:true,
		height: 330,
		striped:true,
		//fitColumns: true,
		singleSelect: true,
		columns:[[
			{field:'TarId',title:'TarId',width:60,hidden:true},
			{field:'HisCode',title:'�շѴ���',width:150},
			{field:'HisDesc',title:'ҽԺ�շ�������',width:300},
			{field:'DW',title:'��λ',width:65},
			{field:'Cate',title:'����',width:50},
			{field:'Price',title:'����',width:50},
			{field:'ConId',title:'ConId',width:10,hidden:true},
			{field:'InsuId',title:'InsuId',width:10,hidden:true},
			{field:'InsuCode',title:'ҽ������',width:80},
			{field:'InsuDesc',title:'ҽ������',width:150},
			{field:'InsuGG',title:'ҽ�����',width:55},
			{field:'InsuDW',title:'ҽ����λ',width:55},
			{field:'InsuSeltPer',title:'�Ը�����',width:55},
			{field:'factory',title:'����',width:150},
			{field:'PZWH',title:'��׼�ĺ�',width:150},
			{field:'InsuCate',title:'ҽ������',width:55},
			{field:'InsuClass',title:'��Ŀ�ȼ�',width:55},
			{field:'conActDate',title:'��Ч����',width:55},
			{field:'index',title:'���',width:55},
			{field:'LimitFlag',title:'�ⲿ����',width:55},
			{field:'HISPutInTime',title:'HIS¼��ʱ��',width:75},
			{field:'SubCate',title:'����',width:50},
			{field:'Demo',title:'�շ��ע',width:100},
			{field:'UserDr',title:'������',width:55},
			{field:'ConDate',title:'��������',width:65},
			{field:'ConTime',title:'����ʱ��',width:65},
			{field:'EndDate',title:'��������',width:65},
			{field:'ConQty',title:'��������',width:55}
		]],
		pagination:false
	});
}

//������λ�õ�datagrid
function loadChangeLoc(){
	var gridJosn=$.cm({
		ClassName:"web.INSUTarContrastCom",
		QueryName:"DhcTarQuery",
		sKeyWord:"�������Ȼ���ע��Һ",
		Class:"3",
		Type:"BJ",
		ConType:"Y",
		TarCate:"1",
		ActDate:"",
		ExpStr:""
	},false);
	
	$HUI.datagrid("#colLocation",{
		rownumbers:true,
		height: 330,
		striped:true,
		//fitColumns: true,
		singleSelect: true,
		data:gridJosn.rows,
		columns:[[
			{field:'TarId',title:'TarId',width:60,hidden:true},
			{field:'HisCode',title:'�շѴ���',width:150},
			{field:'HisDesc',title:'ҽԺ�շ�������'},
			{field:'DW',title:'��λ',width:65},
			{field:'Cate',title:'����',width:50},
			{field:'Price',title:'����',width:50},
			{field:'ConId',title:'ConId',width:10,hidden:true},
			{field:'InsuId',title:'InsuId',width:10,hidden:true},
			{field:'InsuCode',title:'ҽ������',width:80},
			{field:'InsuDesc',title:'ҽ������',width:150},
			{field:'InsuGG',title:'ҽ�����',width:55},
			{field:'InsuDW',title:'ҽ����λ',width:55},
			{field:'InsuSeltPer',title:'�Ը�����',width:55},
			{field:'factory',title:'����',width:150},
			{field:'PZWH',title:'��׼�ĺ�',width:150},
			{field:'InsuCate',title:'ҽ������',width:55},
			{field:'InsuClass',title:'��Ŀ�ȼ�',width:55},
			{field:'conActDate',title:'��Ч����',width:55},
			{field:'index',title:'���',width:55},
			{field:'LimitFlag',title:'�ⲿ����',width:55},
			{field:'HISPutInTime',title:'HIS¼��ʱ��',width:75},
			{field:'SubCate',title:'����',width:50},
			{field:'Demo',title:'�շ��ע',width:100},
			{field:'UserDr',title:'������',width:55},
			{field:'ConDate',title:'��������',width:65},
			{field:'ConTime',title:'����ʱ��',width:65},
			{field:'EndDate',title:'��������',width:65},
			{field:'ConQty',title:'��������',width:55}
		]],
		pagination:false
	});
	$("#colLocation").datagrid("columnMoving");
}

//�������¼�
function loadDataGridFun(){
	//����������
	$HUI.datagrid('#colSort',{
		rowStyler: function(index,row){
			return 'background-color:#ffffff;color:#000000;'; // return inline style
			// the function can return predefined css class and inline style
			// return {class:'r1', style:{'color:#fff'}};	
		}
	}); 
	$HUI.datagrid("#colSort",{
		onClickCell:function(rowIndex,field,value){
			$("#colSortDiv td").css("background-color", "")
			var testJq=$("#colSortDiv td[field='"+field+"']");
			testJq.css("background-color", "#509de1");//509de1   96b8ff
			console.log(field);//��field��ֵ�ַ��� "HisDesc"
			fieldSorTemp=field;
		}
	});
	
	//����������
	$HUI.datagrid('#colHidden',{
		rowStyler: function(index,row){
			return 'background-color:#ffffff;color:#000000;';
		}
	}); 
	
	$HUI.datagrid("#colHidden",{
		onClickCell:function(rowIndex,field,value){
			$("#colHiddenDiv td").css("background-color", "")
			var testJq=$("#colHiddenDiv td[field='"+field+"']");
			testJq.css("background-color", "#509de1");//509de1   96b8ff
			console.log(field);//��field��ֵ�ַ��� "HisDesc"
			fieldHidTemp=field;
		}
	});
}

//�����п��
function savColWid(){
	var colOpts=$HUI.datagrid('#colWidth').getColumnOption("HisDesc");
	console.log(colOpts);//field����
	console.log(colOpts.width);
}

//������λ��
function savColLoc(){
	var opts = $HUI.datagrid('#colLocation').getColumnFields();
	console.log(opts);//��field������["TarId","HisCode","HisDesc","DW"]
	//
}
//������������
function savColSor(){
	console.log(fieldSorTemp);
}

//������������
function savColHid(){
	console.log(fieldHidTemp);
}
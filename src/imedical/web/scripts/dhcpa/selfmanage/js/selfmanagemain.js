//�Բ����
var DSDrowid="";
var projUrl = 'dhc.pa.Selfmanageexe.csp';
var itemGridUrl = '../csp/dhc.pa.Selfmanageexe.csp';
var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'});
var itemGridDs = new Ext.data.Store({
		proxy: itemGridProxy,     //rowid^code^name^frequency^periodTypeName^shortcut^desc^isStop
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	    }, [
			'rowid',
			'code',
			'name',
			'frequency','periodTypeName','isStop','desc','shortcut'	
		]),
	    remoteSort: true
	    //��������صĲ�������remoteSort���������������ʵ�ֺ�̨�����ܵġ�������Ϊ remoteSort:trueʱ��store�������̨��������ʱ�Զ�����sort��dir�����������ֱ��Ӧ������ֶκ�����ķ�ʽ���ɺ�̨��ȡ�������������������ں�̨���������ݽ������������remoteSort:trueҲ�ᵼ��ÿ��ִ��sort()ʱ��Ҫȥ��̨���¼������ݣ�������ֻ�Ա������ݽ�������
});
var itemGridPagingToolbar = new Ext.PagingToolbar({
		pageSize: 20,
		store: itemGridDs,
		atLoad : true,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������"//,

});
//����Ĭ�������ֶκ�������
itemGridDs.setDefaultSort('rowid', 'name');


//���ݿ�����ģ��
var itemGridCm = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(), 
       // new Ext.grid.CheckboxSelectionModel ({singleSelect : false}),
		
        {

            id:'rowid',
            header: '�û�ID',
            allowBlank: false,
            width:200,
            editable:false,
            hidden:true,
            dataIndex: 'rowid'
       },{

            id:'code',
            header: '�Բ����',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'code'
           
       },{

            id:'name',
            header: '�Բ�����',
            allowBlank: false,
           // width:200,
            editable:false,
            dataIndex: 'name'
       },{

            id:'periodTypeName',
            header: '����Ƶ��',
            allowBlank: false,
            width:80,
            editable:false,
            dataIndex: 'periodTypeName'
       } ,{

            id:'isStop',
            header: 'ͣ��',
            allowBlank: false,
            width:50,
            editable:false,
            dataIndex: 'isStop',
	        renderer : function(v){
				return (v=='Y'?'<span style="color:red;">��<span>':'��');
		} 
       },{

            id:'desc',
            header: '����',
            allowBlank: false,
            width:100,
            editable:false,
            hidden:true,
            dataIndex: 'desc'
       },{

            id:'shortcut',
            header: '��д',
            allowBlank: false,
            width:100,
            editable:false,
            hidden:true,
            dataIndex: 'shortcut'
       }      
]);

function trim(str){
	var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}
var addButton = new Ext.Toolbar.Button({
					text : '���',
					iconCls : 'add',
					handler : function() {
						 kpischemAddFun();
						 
				   }
  	});
var altButton = new Ext.Toolbar.Button({
					text : '�޸�',
					tooltip : '�޸�',
					iconCls : 'option',
					handler : function() {
						kpischemEditFun();
					}
				});
/*var altButton = new Ext.Toolbar.Button({
					text : '�޸�',
					iconCls : 'add',
					handler : function() {
						var rowObj = itemGrid.getSelectionModel().getSelections();
						var len = rowObj.length;
						var tmpRowid = "";
		
						if (len < 1) {
							Ext.Msg.show({
								title : 'ע��',
								msg : '��ѡ����Ҫɾ��������!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
						return;
						}; 
						if(len >=2){
							Ext.Msg.show({
								title : 'ע��',
								msg : '������ѡ����Ҫ�޸ĵ�����!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
						return;
						}else{					
							tmpRowid=rowObj[i].get("rowid");
							Alertfun(tmpRowid);
						}
					}
  	});*/
 
var delButton = new Ext.Toolbar.Button({
	text : 'ɾ��',
	tooltip : 'ɾ��',
	iconCls : 'remove',
	handler : function() {
		var rowObj = itemGrid.getSelectionModel().getSelections();
		var len = rowObj.length;
		if (len < 1) {
			Ext.Msg.show({title : 'ע��',msg : '��ѡ����Ҫɾ��������!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.WARNING});
			return;
		} else {
			Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫɾ��ѡ������?', function(btn) {
				if (btn == 'yes') {
					for(var i = 0; i < len; i++){   
		        	    var tmpRowid=rowObj[i].get("rowid");
						Ext.Ajax.request({
							url : '../csp/dhc.pa.Selfmanageexe.csp?action=del&rowid=' + tmpRowid,
							waitMsg : 'ɾ����...',
							failure : function(result, request) {
								Ext.Msg.show({title : '����',msg : '������������!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
							},
							success : function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success == 'true') {
									Ext.Msg.show({title : 'ע��',msg : '�����ɹ�!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
									itemGridDs.load({params : {start : 0,limit : itemGridPagingToolbar.pageSize}});
								} else {
									Ext.Msg.show({title : '����',msg : '����',buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
								}
							},
							scope : this
						});
					}
				}
			});
		}
	}
});

var stopButton = new Ext.Toolbar.Button({
	text : 'ͣ��',

	iconCls : 'remove',
	handler : function(){
		stopFun(itemGrid,itemGridDs,itemGridPagingToolbar,"stop");
	}
});
var activeButton = new Ext.Toolbar.Button({
	text : '����',
	iconCls : 'add',
	handler : function(){
		stopFun(itemGrid,itemGridDs,itemGridPagingToolbar,"active");
	}
});

var itemGrid = new Ext.grid.GridPanel({
		    layout:'fit',
		    //width:400,
		    height:Ext.getBody().getHeight()-30,
		    //autoHeight:true,//��ֻ��ʾһ�����ݣ������ô���
		    readerModel:'local',
		    url: 'dhc.pa.Selfmanageexe.csp',
		    atLoad : true, // �Ƿ��Զ�ˢ��
			store: itemGridDs,
			cm: itemGridCm,//������ģʽ����Ⱦ���ʱ�������ø�������
			trackMouseOver: true,
			stripeRows: true,//����Ƿ���л�ɫ��Ĭ��Ϊfalse 
			autoExpandColumn :'name',
			sm: new Ext.grid.CheckboxSelectionModel({singleSelect:true}), 
			loadMask: true,//�Ƿ��ڼ�������ʱ��ʾ����Ч����Ĭ��Ϊfalse 
			tbar:[addButton,'-',altButton/*,'-',stopButton,'-',activeButton,delButton*/],
			bbar:itemGridPagingToolbar,
				listeners:{  
         			render:function(){  
       				var hd_checker = this.getEl().select('div.x-grid3-hd-checker');  
         				if (hd_checker.hasClass('x-grid3-hd-checker')) {     
                			hd_checker.removeClass('x-grid3-hd-checker'); // ȥ��ȫѡ��   
            			}   
        			}  
			} 
			
});


  itemGridDs.load({	
			params:{start:0, limit:itemGridPagingToolbar.pageSize},
		    callback:function(record,options,success ){
			itemGrid.fireEvent('rowclick',this,0);
			}
})
 itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e){
 	var records = itemGrid.getSelectionModel().getSelections();
 	//if (columnIndex == 4){
 		var rowid  = records[0].get("rowid");
 		DSDrowid = rowid;
 		detailTreeLoader.on('beforeload', function(detailTreeLoader,node){
				if(detailTreeRoot.value!="undefined"){
						var url="../csp/dhc.pa.Selfmanageexe.csp?action=listtree";
						detailTreeLoader.dataUrl=url+"&parent="+node.id+"&rowid="+DSDrowid;
				}
 		})
 		Ext.getCmp("detailReport").root.reload();
 	//}
 });
//================�����ȡҪ�����ڵ�ĺ���====================
//��ȡҪ�����Ľڵ�
var getNode = function(){
	return detailReport.getSelectionModel().getSelectedNode(); 
}
//============================================================

//================���幤�����Լ���ӡ��޸ġ�ɾ����ť==========
//��Ӱ�ť
var addButton=new Ext.Toolbar.Button({
	text:'����Բ���ϸ',
	tooltip:'����Բ���ϸ',
	iconCls: 'add',
	handler:function(){
		addFun(getNode(),DSDrowid);
	}
});
//�޸İ�ť
var updateButton=new Ext.Toolbar.Button({
	text:'���ÿ۷�ϵ��',
	tooltip:'���ÿ۷�ϵ��',
	iconCls: 'add',
	handler:function(){
		updateFun(getNode());
	}
});
//ɾ����ť
var delButton=new Ext.Toolbar.Button({
	text:'ɾ��',
	tooltip:'ɾ��',
	iconCls: 'add',
	handler:function(){
		var rowObj = itemGrid.getSelectionModel().getSelections();
		var schemId=rowObj[0].get("rowid");
	
		delFun(getNode(),schemId);
	}
});

//������
var menubar = [addButton,'-',updateButton,'-',delButton];
//============================================================

//================����ColumnTree�������Ϣ====================
//���νṹ������
var detailTreeLoader = new Ext.tree.TreeLoader({
	dataUrl:'../scripts/ext2/cost/report/test11.csp',
	clearOnLoad:true,
    uiProviders:{
    	'col': Ext.tree.ColumnNodeUI
    }
});
//����ǰ�¼�
detailTreeLoader.on('beforeload', function(detailTreeLoader,node){
	if(detailTreeRoot.value!="undefined"){
		var url="../csp/dhc.pa.Selfmanageexe.csp?action=listtree";
		detailTreeLoader.dataUrl=url+"&parent="+node.id+"&rowid="+DSDrowid;
	}
});
//���νṹ�ĸ�
var detailTreeRoot = new Ext.tree.AsyncTreeNode({
	id:'roo',
    text:'��Ŀ����',
	value:'',
	expanded:false
});
//����չ����ť
/*var colButton = new Ext.Toolbar.Button({
	text:'ȫ������',
	tooltip:'���ȫ��չ����ر�',
	listeners:{click:{fn:detailReportControl}}
});
//����չ������ִ�к���
function detailReportControl(){
	if(colButton.getText()=='ȫ��չ��'){
		colButton.setText('ȫ������');
		detailReport.expandAll();
	}else{
		colButton.setText('ȫ��չ��');
		detailReport.collapseAll();
	}
};*/

//���ͽṹ����
var detailReport = new Ext.tree.ColumnTree({
	id:'detailReport',
	title: '�Բ���Ŀά��',
	height:Ext.getBody().getHeight()-30,
    rootVisible:true,
    autoScroll:true,
	columns:[
	
	{
    	header:'��Ŀ����',
    	align: 'right',
    	width:150,
    	dataIndex:'name'
	},
	
	{
    	header:'��Ŀ����',
    	width:100,
    	dataIndex:'code'
	},
	{
    	header:'˳���',
    	align: 'right',
    	width:100,
    	dataIndex:'order'
	}
	,{
    	header:'��Ŀ���',
    	align: 'right',
    	width:100,
    	dataIndex:'type'
	},{
    	header:'�۷�ϵ��',
    	align: 'right',
    	width:100,
    	dataIndex:'rate'
	}],
    loader:detailTreeLoader,
    root:detailTreeRoot
});
 //�������򣨽���
     new Ext.tree.TreeSorter(detailReport, {   
              property:'code',
              folderSort: false,  
              dir:'asc'          
        }); 


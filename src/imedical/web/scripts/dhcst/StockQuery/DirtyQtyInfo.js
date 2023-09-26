// /����: ռ��������Ϣ��ѯ
// /����: ռ��������Ϣ��ѯ
// /��д�ߣ�zhangdongmei
// /��д����: 2012.08.17

function DirtyQtyQuery(Inclb,IncInfo,Fn) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
		/**
	* ȫ���滻����
	*
	* @param {}
	* str
	* @param {}
	* rgExp
	* @param {}
	* replaceStr
	*/
	function replaceAll(str, rgExp, replaceStr) {
		while (str.indexOf(rgExp) > -1) {
			str = str.replace(rgExp, replaceStr);
		}
		return str;
	}

	IncInfo=replaceAll(IncInfo," ","��"); //��ȫ�ǿո�����ǿո񣬷�ֹlabelչʾ��ʱ���Զ�����ǿո���˵�

	/**
	 * ��ѯ����
	 */
	function searchData() {
		// ��ѡ����
		if (Inclb == null || Inclb.length <= 0) {
			Msg.info("warning", "����������ѡ��ĳһ����¼�鿴��ռ����Ϣ��");
			return;
		}
		
		DirtyQtyStore.load({params:{Params:Inclb}});

	}

	function renderType(value){
		if(value=='T'){
			return '���ⵥ';
		}else if(value=='R'){
			return '�˻���';
		}
	}
		var nm = new Ext.grid.RowNumberer();
		var Cm = new Ext.grid.ColumnModel([nm,  {
					header : "Rowid",
					dataIndex : 'Rowid',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '����',
					dataIndex : 'No',
					width : 200,
					align : 'left',
					sortable : true
				}, {
					header : "����",
					dataIndex : 'Qty',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "��λ",
					dataIndex : 'Uom',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : '��������',
					dataIndex : 'Date',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "��������",
					dataIndex : 'Type',
					width : 80,
					align : 'left',
					renderer:renderType,
					sortable : true
				}]);
		Cm.defaultSortable = false;

		// ����·��
		var DspPhaUrl = DictUrl
					+ 'locitmstkaction.csp?actiontype=GetDirtyQtyInfo';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
					url : DspPhaUrl,
					method : "POST"
				});
		// ָ���в���
		var fields = ["Rowid","No", "Qty", "Uom", "Date","Type"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "Rowid",
					fields : fields
				});
		// ���ݼ�
		var DirtyQtyStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader
				});
	    var Inclbinfo=new Ext.form.Label({
	    	html:IncInfo,
	    	id:'Inclbinfo',
			align:'center',
			cls: 'classImportant',
			style:'font-weight:bold'
	    });
	    Ext.getCmp('Inclbinfo').setText(IncInfo,false)
		var DirtyQtyGrid = new Ext.grid.GridPanel({
					cm : Cm,
					store : DirtyQtyStore,
					trackMouseOver : true,
					stripeRows : true,
					sm : new Ext.grid.CheckboxSelectionModel(),
					loadMask : true,
					tbar:[Inclbinfo],
					listeners:{'rowdblclick':function(grid,rowIndex,event){
							var Type = DirtyQtyStore.getAt(rowIndex).get("Type");
							var Rowid = DirtyQtyStore.getAt(rowIndex).get("Rowid");
							if(Type=='T'){
								Ext.Msg.confirm('��ʾ','�����ɾ����Ӧ���ⵥ��ϸ,ȷ��Ҫ�������ռ������',
	      						function(btn){
	        						if(btn=='yes'){
		        						clearReserveQty(Rowid)						
	        						}
	         	 						
	      						},this);
							}
						
	     				}}
				});
	var window = new Ext.Window({
				title : 'ռ�õ�����Ϣ<˫�������ռ��>',
				width : 600,
				height : 600,
				layout:'fit',
				items : [ DirtyQtyGrid ]
			});
	///�������ռ����
	function clearReserveQty(InItIRowId){
						var url = DictUrl
						+ "dhcinistrfaction.csp?actiontype=DeleteDetail&RowId="
						+ InItIRowId ;
						var loadMask=ShowLoadMask(Ext.getBody(),"������...");
						Ext.Ajax.request({
									url : url,
									method : 'POST',
									waitMsg : '��ѯ��...',
									success : function(result, request) {
										var jsonData = Ext.util.JSON
												.decode(result.responseText);
										if (jsonData.success == 'true') {
											Msg.info("success", "����ɹ�!");
										} else {
											var ret=jsonData.info
											if(ret=="-1"){
												Msg.info("error", "���ʧ��,���ⵥΪ���״̬!");
											}else if(ret=="-2"){
												Msg.info("error", "���ʧ��,���ⵥΪ���״̬!");
											}else if(ret=="-3"){
												Msg.info("error", "���ʧ��,���ⵥΪ�������״̬!");
											}else if(ret=="-4"){
												Msg.info("error", "���ʧ��,���ⵥΪ������״̬!");
											}else{
												Msg.info("error", "���ʧ��,"+jsonData.info);
											}
										
										}
									},
									scope : this
								});	
						loadMask.hide();
						searchData();
	}
	window.on('close', function(panel) {
		Fn()
	});
	window.show();
	searchData();
}
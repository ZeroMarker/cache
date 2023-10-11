var hospid = session['LOGON.HOSPID'];
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var AddCompDRDs = new Ext.data.Store({
						proxy : "",
						url : commonboxUrl+'?action=hospital&rowid='+hospid+'&start=0&limit=10&str=',
						//autoLoad : true,  
						fields: ['rowid','name'],
						reader : new Ext.data.JsonReader({
									totalProperty : "results",
									root : 'rows'
								}, ['rowid', 'name'])
					});

			AddCompDRDs.on('load', function() {

						var Num=AddCompDRDs.getCount();
    					if (Num!=0){
						var id=AddCompDRDs.getAt(0).get('rowid');
						AddCompDRCombo.setValue(id);  
    					} 
					});

			var AddCompDRCombo = new Ext.form.ComboBox({
						id : 'AddCompDRCombo',
						name : 'AddCompDRCombo',
						fieldLabel : 'ҽ�Ƶ�λ',
						store : AddCompDRDs,
						displayField : 'name',
						valueField : 'rowid',
						//allowBlank: false,
						typeAhead : true,
						forceSelection : true,
						triggerAction : 'all',
						emptyText : '',
						width : 70,
						listWidth : 300,
						pageSize : 10,
						minChars : 1,
						anchor: '90%',
						selectOnFocus : true
					});
// �û�///////////////////////////////////

var userDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

userDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : commonboxUrl+'?action=username&flag=1&str='+encodeURIComponent(Ext.getCmp('userCombo').getRawValue()),
						method : 'POST'
					});
		});

var userCombo = new Ext.form.ComboBox({
			id: 'userCombo',
			fieldLabel : '�û�',
			store : userDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '��ѡ��...',
			width : 100,
			listWidth : 200,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});								
var itemGrid = new dhc.herp.Grid({
        title: '������Ϣά��',
        width: 400,
        //edit:false,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'herp.budg.budgbankinformationpreserveexe.csp',	  
		//tbar:delButton,
		atLoad : true, // �Ƿ��Զ�ˢ��
		loadmask:true,
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			edit:false,
            hidden: true
        },{
            id:'CompName',
            header: 'ҽ�Ƶ�λ',
            allowBlank: false,
			width:200,
            dataIndex: 'CompName',
           type: AddCompDRCombo
        },{
            id:'userdr',
            header: '��Ա����',
			allowBlank: false,
			width:200,
            dataIndex: 'userdr',
            type: userCombo
        },{
            id:'atnumber',
            header: '�˺�',
			allowBlank: false,
			width:200,
			 dataIndex: 'atnumber'
           
        },{
            id:'openbank',
            header: '��������',
			allowBlank: false,
			width:200,
			dataIndex: 'openbank'
			
           
        }] 
});

    itemGrid.hiddenButton(3);
    itemGrid.hiddenButton(4);

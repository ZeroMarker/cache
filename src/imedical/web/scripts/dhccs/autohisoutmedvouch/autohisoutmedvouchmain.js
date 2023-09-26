var tmpText1='0001';
var tmpText2='2010��1��23��';
var tmpText3='4��';

//�����������ַ�������ĵĴ�д����
function moneyToCapital(num)  
{
	//var num=source.value;
 
    if(!/^\d*(\.\d*)?$/.test(num)) throw(new Error(-1, "Number is wrong!"));

    var AA = new Array("��","Ҽ","��","��","��","��","½","��","��","��");
    var BB = new Array("","ʰ","��","Ǫ","��","��","Բ","");
    var CC = new Array("��", "��", "��");
    
    var a = (""+ num).replace(/(^0*)/g, "").split("."), k = 0, re = "";

    for(var i=a[0].length-1; i>=0; i--)  //author: meizz
    {
        switch(k)
        {
            case 0 : re = BB[7] + re; break;
            case 4 : if(!new RegExp("0{4}\\d{"+ (a[0].length-i-1) +"}$").test(a[0]))
                     re = BB[4] + re; break;
            case 8 : re = BB[5] + re; BB[7] = BB[5]; k = 0; break;
        }
        if(k%4 == 2 && a[0].charAt(i)=="0" && a[0].charAt(i+2) != "0") re = AA[0] + re;
        if(a[0].charAt(i) != 0) re = AA[a[0].charAt(i)] + BB[k%4] + re; k++;
    }

    if(a.length>1) //����С������(�����С������)
    {
        re += BB[6];
        for(var i=0; i<a[1].length; i++)
        {
          re += AA[a[1].charAt(i)] + CC[i];
          if(i==2) break;
        }
    }
    return re;
};

//alert(moneyToCapital(123456));

var vouchDetailST = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({url:'dhc.cs.autohisoutexe.csp?action=ACCTVouchDetail&vouchNo=40012010070004'}),
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
			}, [
				'rowid',
				'subjDr',
				'summary',
				'subjName',
				'amtCredit',
				'amtDebit'
			]),
		remoteSort: true
	});

//var tmpST = new Ext.data.Store({
//		proxy:	new Ext.data.MemoryProxy([
//			['�������ǯ',1,0,23865.00,'ҩ��'],
//			['�������ǯ',2,23865.00,0,'ҩ��']
//		]),
//		reader: new Ext.data.ArrayReader({},[
//			{name:'Summary'},
//			{name:'AccountingCourses'},
//			{name:'DebitAmount'},
//			{name:'CreditAmount'},
//			{name:'AccountingCoursesName'}
//		])
//	});

//var tmpComboST = new Ext.data.SimpleStore({
//				fields:['value','display'],
//				data:[
//					[1,'101 �ֽ�'],
//					[2,'12301 �������-��ֵ�׺�Ʒ']
//					]
//			});
			
var subjST = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({url:'dhc.cs.autohisoutexe.csp?action=ACCTSubj'}),
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
			}, [
				'rowid',
				'name'
			]),
		remoteSort: true
	});
	
var isZero = function(value){
		return value==0?"":value;
	};
	
var AccountingCoursesCB = new Ext.form.ComboBox({
		id:'tmpCmb',
		hiddenName:'',
		store:subjST,
		//mode:'local',
		valueField:'rowid',
		displayField:'name',
		editable:false,
		//readOnly:true, ����ȥ��
		triggerAction: 'all'
	});
	
AccountingCoursesCB.on(
		'select', 
		function(combo, record, index ){
			tmpRecord = record.get('name');
			autoHisOutMedCm.setRenderer(
				2,
				function(){
					return tmpRecord;
				}
			);
		}
	);
				
var autoHisOutMedCm = new Ext.grid.ColumnModel([
    new Ext.grid.RowNumberer(),
    {
        header: 'ժҪ',
        dataIndex: 'summary',
        width: 200,
        align: 'left',
        sortable: true
    },
    {
        header: "��ƿ�Ŀ",
        dataIndex: 'subjDr',
        width: 400,
        align: 'left',
		editor:AccountingCoursesCB,
		renderer:function(value,metadata,record,rowIndex,colIndex,store){
			return record.get('subjName');
		},
        sortable: true
    },
    {
        header: "�跽���",
        dataIndex: 'amtCredit',
        width: 200,
        align: 'left',
		renderer: isZero,
        sortable: true
    },
    {
        header: "�������",
        dataIndex: 'amtDebit',
        width: 200,
        align: 'left',
		renderer: isZero,
        sortable: true
    }
]);

var autohisoutmedvouchForm = new Ext.form.FormPanel({
		title:	'����ƾ֤',
		region:	'north',
		frame:	true,
		height:	130,
		items:	[	
					{
						xtype: 'panel',
						layout:"column",
						hideLabel:true,
						isFormField:true,
						items: [
							{
								columnWidth:.9,
								xtype:'displayfield'
							},
							{
								columnWidth:.05,
								xtype:'button',
								text: '����',
								name: 'bc',
								tooltip: '����',  
								handler:function(b){
										//alert(b.text);
									},
								iconCls: 'add'
							},
							{
								columnWidth:.05,
								xtype:'button',
								text: '�ر�',
								name: 'gb',
								tooltip: '�ر�', 
								handler:function(b){
										//alert(b.text);
									},
								iconCls: 'add'
							}
						]
					},
					{
						xtype: 'panel',
						layout:"column",
						hideLabel:true,
						isFormField:true,
						items: [
							{
								columnWidth:.9,
								xtype: 'displayfield', 
								value: '<font size="6px"><center>����ƾ֤</center></font>'
							}
						]
					},
					{
						xtype: 'panel',
						layout:"column",
						hideLabel:true,
						isFormField:true,
						items: [
							{
								columnWidth:.1,
								xtype:'displayfield'
							},
							{
								columnWidth:.3,
								xtype:'displayfield',
								value: 'ƾ֤��ţ�'+tmpText1
							},
							{
								columnWidth:.3,
								xtype:'displayfield',
								value: '���ڣ�'+tmpText2
							},
							{
								columnWidth:.3,
								xtype:'displayfield',
								value: '����������'+tmpText3
							}
						]
					}
				]
	});

var autohisoutmedvouchMain = new Ext.grid.EditorGridPanel({
		//title: '����ƾ֤',
		store: vouchDetailST, ////////////////temp
		cm: autoHisOutMedCm,
		region:'center',
		clicksToEdit: 1,
		trackMouseOver: true,
		stripeRows: true,
		bbar: ['�� �ƣ���д��:'],
		loadMask: true
	});
	
vouchDetailST.load({
		callback : function(r){
			autohisoutmedvouchMain.getBottomToolbar().add(moneyToCapital(r[r.length-1].get('amtCredit'))+'Ԫ��');
			//alert(r[r.length-1].get('rowid'));
		}
	});
subjST.load();////�ǳ���Ҫ

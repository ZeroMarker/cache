var tmpText1='0001';
var tmpText2='2010年1月23日';
var tmpText3='4张';

//将阿拉伯数字翻译成中文的大写数字
function moneyToCapital(num)  
{
	//var num=source.value;
 
    if(!/^\d*(\.\d*)?$/.test(num)) throw(new Error(-1, "Number is wrong!"));

    var AA = new Array("零","壹","贰","叁","肆","伍","陆","柒","捌","玖");
    var BB = new Array("","拾","佰","仟","万","亿","圆","");
    var CC = new Array("角", "分", "厘");
    
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

    if(a.length>1) //加上小数部分(如果有小数部分)
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
//			['购买拆线钳',1,0,23865.00,'药房'],
//			['购买拆线钳',2,23865.00,0,'药库']
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
//					[1,'101 现金'],
//					[2,'12301 库存物资-低值易耗品']
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
		//readOnly:true, 必须去掉
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
        header: '摘要',
        dataIndex: 'summary',
        width: 200,
        align: 'left',
        sortable: true
    },
    {
        header: "会计科目",
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
        header: "借方金额",
        dataIndex: 'amtCredit',
        width: 200,
        align: 'left',
		renderer: isZero,
        sortable: true
    },
    {
        header: "贷方金额",
        dataIndex: 'amtDebit',
        width: 200,
        align: 'left',
		renderer: isZero,
        sortable: true
    }
]);

var autohisoutmedvouchForm = new Ext.form.FormPanel({
		title:	'记账凭证',
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
								text: '保存',
								name: 'bc',
								tooltip: '保存',  
								handler:function(b){
										//alert(b.text);
									},
								iconCls: 'add'
							},
							{
								columnWidth:.05,
								xtype:'button',
								text: '关闭',
								name: 'gb',
								tooltip: '关闭', 
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
								value: '<font size="6px"><center>记账凭证</center></font>'
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
								value: '凭证编号：'+tmpText1
							},
							{
								columnWidth:.3,
								xtype:'displayfield',
								value: '日期：'+tmpText2
							},
							{
								columnWidth:.3,
								xtype:'displayfield',
								value: '附件张数：'+tmpText3
							}
						]
					}
				]
	});

var autohisoutmedvouchMain = new Ext.grid.EditorGridPanel({
		//title: '记账凭证',
		store: vouchDetailST, ////////////////temp
		cm: autoHisOutMedCm,
		region:'center',
		clicksToEdit: 1,
		trackMouseOver: true,
		stripeRows: true,
		bbar: ['合 计（大写）:'],
		loadMask: true
	});
	
vouchDetailST.load({
		callback : function(r){
			autohisoutmedvouchMain.getBottomToolbar().add(moneyToCapital(r[r.length-1].get('amtCredit'))+'元整');
			//alert(r[r.length-1].get('rowid'));
		}
	});
subjST.load();////非常重要

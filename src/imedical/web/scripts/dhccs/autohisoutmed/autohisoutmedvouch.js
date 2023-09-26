autohisoutmedvouchFun = function(grid, rowIndex, columnIndex, e) {

	//var tmpText1='0001';
	//var tmpText2='2010年1月23日';
	//var tmpText3='4张';
	
	var selectedRec = grid.getStore().getAt(rowIndex);
	
	var fieldVouchNO = grid.getColumnModel().getDataIndex(8);
	var fieldDate = grid.getColumnModel().getDataIndex(3);
	
	var fieldVouchNO = selectedRec.get(fieldVouchNO);
	var dataDate = selectedRec.get(fieldDate);
	
	fieldVouchNO=(fieldVouchNO==undefined)?"":fieldVouchNO;
	dataDate=(dataDate==undefined)?"":dataDate;

	//alert(fieldVouchNO+","+dataDate);
	
	var tmpCount=0;
	
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
	
	
	//将数字金额进行千位分隔 
	function formatNum(val){ 
		//val = FormatNumber(val,2);
		//	val = tofloat(val,2); 
	
		val = xf(val,2);
	
		//alert(val);
	
		var digit = val.indexOf("."); // 取得小数点的位置 
		var int = val.substr(0,digit); // 取得小数中的整数部分 
		var minusFlag = 0;
		if (val.indexOf("-") != -1) { //负数时
			minusFlag = 1;
			int = int.substr(1,int.length-1); // 取得负数中的负号后部分 
		}
		var i; 
		var mag = new Array(); 
		var word; 
		if (val.indexOf(".") == -1) { // 整数时 
			i = val.length; // 整数的个数 
			while(i > 0) { 
				word = val.substring(i,i-3); // 每隔3位截取一组数字 
				i-= 3; 
				mag.unshift(word); // 分别将截取的数字压入数组 
			} 
			val = mag; 
		} 
		else{ // 小数时 
			i = int.length; // 除小数外，整数部分的个数 
			while(i > 0) { 
				word = int.substring(i,i-3); // 每隔3位截取一组数字 
				i-= 3; 
				mag.unshift(word); 
			} 
			val = mag + val.substring(digit); 
		} 
		if (minusFlag == 1) { //负数时
			val = '-' + val;
		}
		return val;
	}; 
	
	function xf(Str,nAfterDotParam) 
	{ 
		var Str = Str.toString(); 
		var dot = Str.indexOf("."); 
		var Strlength = Str.length; 
		
		if(nAfterDotParam<=0) 
		{ 
			return Str; 
		} 
		if(dot==-1) 
		{ 
			Str+="."; 
			for(i=0;i<nAfterDotParam;i++) 
			{ 
				Str +="0"; 
			} 
			} 
		else 
		{ 
			var strArray = Str.split("."); 
			if(strArray[1].length <nAfterDotParam) 
			{ 
				for(i=0;i<nAfterDotParam-strArray[1].length;i++) 
				{ 
					Str += "0"; 
				} 
			} 
			else 
			{ 
				var x =1; 
				for(i=0;i<nAfterDotParam;i++) 
				{ 
					x=x*10; 
				} 
				Str = (Math.round(parseFloat(Str*x))/x).toString(); 
					
			} 
		} 
		return Str; 
	}; 
	
	var vouchDetailST = new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({url:'dhc.cs.autohisoutexe.csp?action=ACCTVouchDetail&vouchNo='+fieldVouchNO}),
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
			//value = new Number(value);			
			//value = value.toFixed(2);	
			value = formatNum(value);			
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
			//editable:false,
			renderer:function(value,metadata,record,rowIndex,colIndex,store){
				return record.get('subjName');
			},
			sortable: true
		},
		{
			header: "借方金额",
			dataIndex: 'amtDebit',
			width: 200,
			align: 'right',
			renderer: isZero,
			sortable: true
		},
		{
			header: "贷方金额",
			dataIndex: 'amtCredit',
			width: 200,
			align: 'right',
			renderer: isZero,
			sortable: true
		}
	]);
	
	var autohisoutmedvouchForm = new Ext.form.FormPanel({
			//title:'记账凭证',
			region:	'north',
			frame:	true,
			height:	105,
			items:	[	
						{
							xtype: 'panel',
							layout:"column",
							hideLabel:true,
							isFormField:true,
							items: [
								{
									columnWidth:.95,
									xtype:'displayfield'
								},
								{
									columnWidth:.05,
									xtype:'button',
									text: '保存',
									name: 'bc',
									tooltip: '保存',  
									handler:function(b){
											//this.grid.getStore().getModifiedRecords();,然后取出值,再拼成几个串然后提交到后台,后台只能自己用request.getParameter()去取了,
											//提交成功后在调用this.grid.getStore().commitChanges();
											var tmpModifiedRecs = vouchDetailST.getModifiedRecords();
											for(var i=0; i<tmpModifiedRecs.length; i++){
												var tmpAMod=tmpModifiedRecs[i];
												//alert(tmpAMod.get('rowid')+','+tmpAMod.get('subjDr'));
												Ext.Ajax.request({
													url: 'dhc.cs.autohisoutexe.csp?action=ACCTVouchDetailUpdate&rowid='+tmpAMod.get('rowid')+'&subjDr='+tmpAMod.get('subjDr'),
													waitMsg:'保存中...',
													failure: function(result, request) {
														Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
													},
													success: function(result, request) {
														var jsonData = Ext.util.JSON.decode( result.responseText );
														if (jsonData.success=='true') {
															Ext.Msg.show({title:'注意',msg:'保存成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});

														}else{
															Ext.Msg.show({title:'错误',msg:'保存失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
														}
													},
													scope: this
												});
											}
											vouchDetailST.commitChanges();
										},
									iconCls: 'add'
								}//,
								//{
								//	columnWidth:.05,
								//	xtype:'button',
								//	text: '关闭',
								//	name: 'gb',
								//	tooltip: '关闭', 
								//	handler:function(b){
								//			//alert(b.text);
								//		},
								//	iconCls: 'add'
								//}
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
							id:'tmpdisp',
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
									value: '凭证编号：'+fieldVouchNO
								},
								{
									columnWidth:.3,
									xtype:'displayfield',
									value: '日期：'+dataDate
								}//,
								//{
								//	columnWidth:.3,
								//	xtype:'displayfield',
								//	value: '附件张数：'//+tmpText3
								//}
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
		
	var autohisoutmedvouchWin = new Ext.Window({
			//title:'记账凭证',
			width:1050,
			height:600,
			minWidth:1050,
			minHeight:600,
			layout:'border',
			plain:true,
			modal:true,
			//bodyStyle:'padding:5px;',
			items: [autohisoutmedvouchForm,autohisoutmedvouchMain]
		});
		
	vouchDetailST.load({
			callback : function(r){
				var tmpd = Ext.getCmp('tmpdisp')
				tmpd.add({
					columnWidth:.3,
					xtype:'displayfield',
					value: '附件张数： '+(r.length-1)+'张'
				}); 
				tmpd.doLayout(); //刷新!!!!!!!!!!!
				tmpMon = (moneyToCapital(r[r.length-1].get('amtCredit'))==''?'零':moneyToCapital(r[r.length-1].get('amtCredit')))
				autohisoutmedvouchMain.getBottomToolbar().add(tmpMon+'元整');
				tmpCount=r.length;
				autohisoutmedvouchMain.getBottomToolbar().doLayout();
			}
		});
		
	
	autohisoutmedvouchMain.on(
			'cellclick', 
			function(grid, rowIndex, columnIndex, e){
				//alert(rowIndex+','+columnIndex+','+tmpCount);
				if((columnIndex==2)&&(rowIndex==tmpCount-1)){
					//alert(rowIndex+','+columnIndex);
					autoHisOutMedCm.setEditable(2,false);
				}else{
					autoHisOutMedCm.setEditable(2,true);
				}
			}
		);
		
	subjST.load();////非常重要
	autohisoutmedvouchWin.show();

};
var data="";
var monthStore="";
//Ext.Ajax.timeout=90000000000000; 加上这句请求会取消
var userCode=session['LOGON.USERCODE'];
var cycleDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
});

cycleDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:'dhc.pa.calculatorexe.csp?action=cycle&searchValue='+Ext.getCmp('cycleField').getRawValue()+'&active=Y',method:'POST'})
});

var cycleField = new Ext.form.ComboBox({
	id: 'cycleField',
	fieldLabel:'考核周期',
	width:180,
	listWidth : 200,
	allowBlank: false,
	store: cycleDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择考核周期...',
	name: 'cycleField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var periodTypeStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['M','月'],['Q','季'],['H','半年'],['Y','年']]
});
var periodTypeField = new Ext.form.ComboBox({
	id: 'periodTypeField',
	fieldLabel: '期间类型',
	width:180,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: periodTypeStore,
	anchor: '90%',
	value:'', //默认值
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'选择期间类型...',
	mode: 'local', //本地模式
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

periodTypeField.on("select",function(cmb,rec,id){
	if(cmb.getValue()=="M"){
		data=[['1','01月'],['2','02月'],['3','03月'],['4','04月'],['5','05月'],['6','06月'],['7','07月'],['8','08月'],['9','09月'],['10','10月'],['11','11月'],['12','12月']];
	}
	if(cmb.getValue()=="Q"){
		data=[['1','01季度'],['2','02季度'],['3','03季度'],['4','04季度']];
	}
	if(cmb.getValue()=="H"){
		data=[['1','1~6上半年'],['2','7~12下半年']];
	}
	if(cmb.getValue()=="Y"){
		data=[['0','全年']];
	}
	periodStore.loadData(data);
});
periodStore = new Ext.data.SimpleStore({
	fields:['key','keyValue']
});

var periodField = new Ext.form.ComboBox({
	id: 'periodField',
	fieldLabel: '',
	width:180,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: periodStore,
	anchor: '90%',
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'请选择...',
	mode: 'local', //本地模式
	editable:false,
	pageSize: 12,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});


var schemDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','parRef','code','name','shortcut','appSysDr','frequency','KPIDr','KPIName','desc','level','appSys','quency','shortCutFreQuency'])
});

schemDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:'dhc.pa.disttargetexe.csp?action=schem&searchField=name&searchValue='+encodeURIComponent(Ext.getCmp('schem').getRawValue())+'&active=Y&type='+Ext.getCmp('periodTypeField').getValue(),method:'POST'})
});
var schem = new Ext.form.ComboBox({
	id: 'schem',
	fieldLabel: '当前方案',
	width:180,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: schemDs,
	anchor: '90%',
	displayField:'shortCutFreQuency',
	valueField: 'rowid',
	triggerAction: 'all',
	emptyText:'选择当前方案...',
	editable:true,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

var autohisoutmedvouchForm = new Ext.form.FormPanel({
		title:'★考评计算',
		region:'north',
		frame:true,
		height:90,
		items:[{
			xtype: 'panel',
			layout:"column",
			height:25,
			hideLabel:true,
			isFormField:true,
			items:[
					{columnWidth:.0,xtype:'displayfield'},
					{columnWidth:.2,xtype:'label',text: '☆ 绩效考核---考评计算 ☆'}
				]
			},{
			xtype: 'panel',
			layout:"column",
			hideLabel:true,
			height:50,
			isFormField:true,
			items:[
					{columnWidth:.07,xtype:'label',text: '年度:'},
					cycleField,
					{columnWidth:.02,xtype:'displayfield'},
					{columnWidth:.15,xtype:'label',text: '期间类型:'},
					periodTypeField,
					{columnWidth:.02,xtype:'displayfield'},
					{columnWidth:.1,xtype:'label',text: '期间:'},
					periodField,
					{columnWidth:.06,xtype:'displayfield'},
					{columnWidth:.15,xtype:'label',text:'考核方案:'},
					schem
				]
			},{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:30,
				isFormField:true,
				items:[
					{columnWidth:.07,xtype:'label',text: '一、分步式计算'}
				]
			},{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:25,
				isFormField:true,
				items:[
					{columnWidth:.02,xtype:'displayfield'},
					{columnWidth:.08,xtype:'label',text: '1.基本指标计算:'},
					{columnWidth:.01,xtype:'displayfield'},
					{columnWidth:.05,xtype:'button',text: '指标计算',name: 'bc',tooltip: '指标计算',handler:function(){kpical()},iconCls: 'remove'}
				]
			},{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:25,
				isFormField:true,
				items:[
					{columnWidth:.02,xtype:'displayfield'},
					{columnWidth:.08,xtype:'label',text: '2.考核分计算:'},
					{columnWidth:.01,xtype:'displayfield'},
					{columnWidth:.05,xtype:'button',text: '考核分计算',name: 'bc',tooltip: '考核分计算',handler:function(){asscal()},iconCls: 'remove'}
				]
			},{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:20,
				isFormField:true,
				items:[
					{columnWidth:.02,xtype:'displayfield'},
					{columnWidth:.35,xtype:'label',text: '3.分步式计算说明:'}
				]
			},{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:50,
				isFormField:true,
				items:[
					{columnWidth:.05,xtype:'displayfield'},
					{columnWidth:.6,xtype:'label',text:'分步式计算步骤： 基本指标计算->考核分计算'}
				]
			}/*,{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:30,
				isFormField:true,
				items:[
					{columnWidth:.07,xtype:'label',text: '二、全部计算'},
					{columnWidth:.01,xtype:'displayfield'},
					{columnWidth:.05,
						xtype:'button',
						text: '计算',
						name: 'bc',
						tooltip: '全部计算',
						iconCls: 'remove',
						handler:function(){
							//所有指标计算
							allcal();
							//所有分数计算
							allScoreCal();
						}
					}
				]
			},{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:20,
				isFormField:true,
				items:[
					{columnWidth:.02,xtype:'displayfield'},
					{columnWidth:.15,xtype:'label',text: '1.全部计算说明:'}
				]
			},{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:50,
				isFormField:true,
				items:[
					{columnWidth:.05,xtype:'displayfield'},
					{columnWidth:.6,xtype:'label',text:'全部计算： 完成分布计算的全过程'}
				]
			}*/,{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:50,
				isFormField:true,
				items:[
					{columnWidth:.40,xtype:'displayfield'},
					{columnWidth:.2,xtype:'label',text: '※ 友情提示： 请仔细选择各个参数 ※'}
				]
			}
		]
});

//替换表达式中的"{"符号
replace3=function(expression){
	var re=/{/g; //创建正则表达式模式
	var newExpression=expression.replace(re,"(");
	return newExpression;
}

//替换表达式中的"}"符号
replace4=function(expression){
	var re=/}/g; //创建正则表达式模式
	var newExpression=expression.replace(re,")");
	return newExpression;
}

//替换表达式中的"["符号
replace1=function(expression){
	var re=/\[/g; //创建正则表达式模式
	var newExpression=expression.replace(re,"(");
	return newExpression;
}

//替换表达式中的"]"符号
replace2=function(expression){
	var re=/]/g; //创建正则表达式模式
	var newExpression=expression.replace(re,")");
	return newExpression;
}

//总替换
totalReplace=function(expression){
	return replace4(replace3(replace2(replace1(expression))));
}

var cycleDr="";
var periodType="";
var period="";
var schemDr="";

//获取参数
getParams=function(){
	cycleDr=Ext.getCmp('cycleField').getValue();
	if(cycleDr==""){
		Ext.Msg.show({title:'注意',msg:'请选择年度!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}
	periodType=Ext.getCmp('periodTypeField').getValue();
	if(periodType==""){
		Ext.Msg.show({title:'注意',msg:'请期间类型!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}
	period=Ext.getCmp('periodField').getValue();
	if(period==""){
		Ext.Msg.show({title:'注意',msg:'请选择期间!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}
	schemDr=Ext.getCmp('schem').getValue();
	if(schemDr==""){
		 schemDr="1"
	}
	//alert("schemDr="+schemDr);
	/*
	if(schemDr==""){
		Ext.Msg.show({title:'注意',msg:'请选择!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}
	*/
	
}

//计算公式中有“0”的指标,主要是提示用户
var InfinityKPINameStr="";
//计算公式中有为空的指标,主要是提示用户
var noKPINameStr="";
//新的字符串信息
var newAllInfo="";

//处理字符串信息newPeriod_"^"_jxUnitName_"^"_KPIName
strDeal = function(str){
	var allArray=str.split("!");
	var length=allArray.length;
							
	for(var i=0;i<length;i++){
		var info=allArray[i];
		var infoArray=info.split("^");
		var infoLength=infoArray.length;
		var expression=infoArray[infoLength-1];
		if(expression!=""){
			var newExpression=totalReplace(expression);
			//计算公式
			var value=eval(newExpression);
			//alert(value);	
			/*
			if(value=="Infinity"){
				var KPIName=infoArray[4];
				if(InfinityKPINameStr==""){
					InfinityKPINameStr=KPIName;
				}else{
					InfinityKPINameStr=InfinityKPINameStr+"^"+KPIName
				}
				if(newAllInfo==""){
					newAllInfo=allArray[i]+"^"+value;
				}else{
					newAllInfo=newAllInfo+"!"+allArray[i]+"^"+value;
				}
			}else{
				if(newAllInfo==""){
					newAllInfo=allArray[i]+"^"+value;
				}else{
					newAllInfo=newAllInfo+"!"+allArray[i]+"^"+value;
				}
			}
			*/
			if((value!="Infinity")||(value!="NaN")){
				var KPIName=infoArray[4];
				if(InfinityKPINameStr==""){
					InfinityKPINameStr=KPIName;
				}else{
					InfinityKPINameStr=InfinityKPINameStr+"^"+KPIName
				}
				if(newAllInfo==""){
					newAllInfo=allArray[i]+"^"+value;
				}else{
					newAllInfo=newAllInfo+"!"+allArray[i]+"^"+value;
				}
			}else{
				if(newAllInfo==""){
					newAllInfo=allArray[i]+"^"+value;
				}else{
					newAllInfo=newAllInfo+"!"+allArray[i]+"^"+value;
				}
			}
		}else{
			var value="";
			var KPIName=infoArray[4];
			if(noKPINameStr==""){
				noKPINameStr=KPIName;
			}else{
				noKPINameStr=noKPINameStr+"^"+KPIName
			}
			if(newAllInfo==""){
				newAllInfo=allArray[i]+"^"+value;
			}else{
				newAllInfo=newAllInfo+"!"+allArray[i]+"^"+value;
			}
		}
	}
}

//处理字符串信息newPeriod_"^"_jxUnitName_"^"_KPIName
strDeal2 = function(str){
	var allArray=str.split("!");
	var length=allArray.length;
							
	for(var i=0;i<length;i++){
		var info=allArray[i];
		var infoArray=info.split("^");
		var infoLength=infoArray.length;
		var expression=infoArray[infoLength-1];
		if(expression!=""){
			var newExpression=totalReplace(expression);
			//计算公式
			var value=eval(newExpression);
			//alert(value);	
			/*
			if(value=="Infinity"){
				var KPIName=infoArray[4];
				if(InfinityKPINameStr==""){
					InfinityKPINameStr=KPIName;
				}else{
					InfinityKPINameStr=InfinityKPINameStr+"^"+KPIName
				}
				if(newAllInfo==""){
					newAllInfo=allArray[i]+"^"+value;
				}else{
					newAllInfo=newAllInfo+"!"+allArray[i]+"^"+value;
				}
			}else{
				if(newAllInfo==""){
					newAllInfo=allArray[i]+"^"+value;
				}else{
					newAllInfo=newAllInfo+"!"+allArray[i]+"^"+value;
				}
			}
			*/
			if((value!="Infinity")||(value!="NaN")){
				var KPIName=infoArray[4];
				if(InfinityKPINameStr==""){
					InfinityKPINameStr=KPIName;
				}else{
					InfinityKPINameStr=InfinityKPINameStr+"^"+KPIName
				}
				if(newAllInfo==""){
					newAllInfo=allArray[i]+"^"+value;
				}else{
					newAllInfo=newAllInfo+"!"+allArray[i]+"^"+value;
				}
			}else{
				if(newAllInfo==""){
					newAllInfo=allArray[i]+"^"+value;
				}else{
					newAllInfo=newAllInfo+"!"+allArray[i]+"^"+value;
				}
			}
		}else{
			var value="";
			var KPIName=infoArray[4];
			if(noKPINameStr==""){
				noKPINameStr=KPIName;
			}else{
				noKPINameStr=noKPINameStr+"^"+KPIName
			}
			if(newAllInfo==""){
				newAllInfo=allArray[i]+"^"+value;
			}else{
				newAllInfo=newAllInfo+"!"+allArray[i]+"^"+value;
			}
		}
	}
}

//所有公式中只含有公式为空的情况
expreNull=function(){
	getParams();
	function callback3(id){
		if(id=="yes"){
			Ext.Ajax.request({
				url: 'dhc.pa.calculatorexe.csp?action=calcul&allinfo='+newAllInfo,
				waitMsg:'保存中...',
				failure: function(result, request){
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'注意',msg:'计算指标成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					}else{
						if(jsonData.info=='false'){
							Ext.Msg.show({title:'提示',msg:'计算指标失败,数据被回滚!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}
						if(jsonData.info=='NoDeal'){
							Ext.Msg.show({title:'提示',msg:'参数丢失,计算不执行,数据未产生错误,请检查参数传入问题!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}
					}
				},
				scope: this
			});
		}else{
			return;
		}
	}
	Ext.MessageBox.confirm('提示',noKPINameStr+'等指标无计算公式,确定要计算吗?',callback3);
}

//所有公式中只含有分母为0的情况
zeroNull=function(){
	getParams();
	function callback2(id){
		if(id=="yes"){
			Ext.Ajax.request({
				url: 'dhc.pa.calculatorexe.csp?action=calcul&allinfo='+newAllInfo,
				waitMsg:'保存中...',
				failure: function(result, request){
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'注意',msg:'计算指标成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					}else{
						if(jsonData.info=='false'){
							Ext.Msg.show({title:'提示',msg:'计算指标失败,数据被回滚!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}
						if(jsonData.info=='NoDeal'){
							Ext.Msg.show({title:'提示',msg:'参数丢失,计算不执行,数据未产生错误,请检查参数传入问题!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}
					}
				},
				scope: this
			});
		}else{
			return;
		}
	}
	Ext.MessageBox.confirm('提示',InfinityKPINameStr+'等指标中分母为0,请查看指标记录,确定要计算吗?',callback2);
}

//所有公式中既包括公式为空,又包括分母为0的情况
bothNull=function(){
	getParams();
	function callback4(id){
		if(id=="yes"){
			Ext.Ajax.request({
				url: 'dhc.pa.calculatorexe.csp?action=calcul&allinfo='+newAllInfo,
				waitMsg:'保存中...',
				failure: function(result, request){
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'注意',msg:'计算指标成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					}else{
						if(jsonData.info=='false'){
							Ext.Msg.show({title:'提示',msg:'计算指标失败,数据被回滚!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}
						if(jsonData.info=='NoDeal'){
							Ext.Msg.show({title:'提示',msg:'参数丢失,计算不执行,数据未产生错误,请检查参数传入问题!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}
					}
				},
				scope: this
			});
		}else{
			return;
		}
	}
	Ext.MessageBox.confirm('提示',noKPINameStr+'等指标无计算公式,'+InfinityKPINameStr+'等指标中分母为0,请查看指标记录,确定要计算吗?',callback4);
}

//所有公式中既不包括分母为0又不包括公式为空的情况
bothNoNull=function(){
	getParams();
	function callback1(id){
		if(id=="yes"){
			Ext.Ajax.request({
				url: 'dhc.pa.calculatorexe.csp?action=calcul&allinfo='+newAllInfo,
				waitMsg:'保存中...',
				failure: function(result,request){
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result,request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'注意',msg:'计算指标成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					}else{
						if(jsonData.info=='false'){
							Ext.Msg.show({title:'提示',msg:'计算指标失败,数据被回滚!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}
						if(jsonData.info=='NoDeal'){
							Ext.Msg.show({title:'提示',msg:'参数丢失,计算不执行,数据未产生错误,请检查参数传入问题!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}
					}
				},
				scope: this
			});
		}else{
			return;
		}
	}
	Ext.MessageBox.confirm('提示','指标计算公式完全正确,确定要计算吗?',callback1);
}

//根据条件执行方法
publicFun=function(){
	//0、null
	if((noKPINameStr!="")&&(InfinityKPINameStr!="")){
		bothNull();
		//alert("a");
	}
	//null
	if((noKPINameStr!="")&&(InfinityKPINameStr=="")){
		expreNull();
		//alert("b");
	}
	//0
	if((noKPINameStr=="")&&(InfinityKPINameStr!="")){
		zeroNull();
		//alert("c");
	}
	//正常
	if((noKPINameStr=="")&&(InfinityKPINameStr=="")){
		bothNoNull();
		//alert("d");
	}
}

//指标计算方法
kpical = function(){
	getParams();
	//alert('dhc.pa.calculatorexe.csp?action=getallinfo&period='+period+'&cycleDr='+cycleDr+'&periodType='+periodType+'&schemDr='+schemDr);
	Ext.Ajax.request({
		url: 'dhc.pa.calculatorexe.csp?action=getallinfo&period='+period+'&cycleDr='+cycleDr+'&periodType='+periodType+'&schemDr='+schemDr+'&userCode='+userCode,
		waitMsg:'保存中...',
		failure: function(result, request){
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request){
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true'){
				if(jsonData.info.split("%").length==1){
					if(jsonData.info=="UnCycle"){
						Ext.Msg.show({title:'提示',msg:'考核年度丢失!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						return false;
					}
					if(jsonData.info=="UnFrequency"){
						Ext.Msg.show({title:'提示',msg:'期间类型丢失!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						return false;
					}
					if(jsonData.info=="UnPeriod"){
						Ext.Msg.show({title:'提示',msg:'考核期间丢失!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						return false;
					}
					if(jsonData.info=="NoCurrStratagem"){
						Ext.Msg.show({title:'提示',msg:'多个当前战略或无当前战略!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						return false;
					}
				}else{
					var arr=jsonData.info.split("%");
					var flag=arr[1];
					if(flag=="true"){
					
						Ext.Msg.show({title:'提示',msg:'计算性指标执行成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					}else{
						//提示用户检查返回的指标
						Ext.Msg.show({title:'提示',msg:'指标计算执行失败,请检查'+arr[0]+'指标再计算!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					}
				}
			}
		},
		scope: this
	});
}

//考核分计算
asscal=function(){
	
	getParams();
	Ext.Ajax.request({
		url: 'dhc.pa.calculatorexe.csp?action=assscore&period='+period+'&cycleDr='+cycleDr+'&periodType='+periodType+'&schemDr='+schemDr+'&userCode='+userCode,
		waitMsg:'保存中...',
	
		
	
		failure: function(result, request){

			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
	/**
		failure: function(XMLHttpRequest, textStatus, errorThrown){
		alert(XMLHttpRequest.status); //500
		alert(XMLHttpRequest.readyState); // un 
		alert(textStatus); // obj
		},
	
**/
		success: function(result, request){
		
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true'){
			//alert(Ext.Ajax.timeout);
				Ext.Msg.show({title:'提示',msg:'该方案的考核分计算成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}else{
				if(jsonData.info=="NoCycle"){
					Ext.Msg.show({title:'提示',msg:'年度丢失,程序终止!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=="NoFreq"){
					Ext.Msg.show({title:'提示',msg:'报告频率丢失,程序终止!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=="NoPeriod"){
					Ext.Msg.show({title:'提示',msg:'考核期间丢失,程序终止!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=="NoCurrStratagem"){
					Ext.Msg.show({title:'提示',msg:'缺少当前战略丢失,程序终止!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
			}
		},
	
		scope: this
	});
}
//====================================================================================================================
/*
//全部计算过程
//1.全部指标计算
allcal=function(){
	getParams();
	Ext.Ajax.request({
		url: 'dhc.pa.calculatorexe.csp?action=allcal',
		waitMsg:'保存中...',
		failure: function(result, request){
			
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request){
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true'){
				var arr=jsonData.info.split("%");
				var flag=arr[1];
				if(flag=="true"){
			     function callback(id){
						if(id=="yes"){
							//全部指标计算
							strDeal(arr[0]);
							publicFun();
						}else{
							return false;
						}
					
					Ext.MessageBox.confirm('提示','非计算性指标已执行成功,还要往下执行计算性指标吗?',callback);
				}else{
					Ext.Msg.show({title:'提示',msg:'非计算性指标执行失败,程序终止!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			}
		},
		 scope:this
	});


//2.全部分数计算
allScoreCal=function(){
	getParams();
	Ext.Ajax.request({
		url: 'dhc.pa.calculatorexe.csp?action=allScoreCal&cycleDr='+cycleDr,
		waitMsg:'保存中...',
		failure: function(result, request){
		
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request){
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true'){
				Ext.Msg.show({title:'提示',msg:'该方案的考核分计算成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}else{
				if(jsonData.info=="NoCycle"){
					Ext.Msg.show({title:'提示',msg:'年度丢失,程序终止!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
				if(jsonData.info=="NoCurrStratagem"){
					Ext.Msg.show({title:'提示',msg:'缺少当前战略丢失,程序终止!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
				if(jsonData.info=="NoCurrMonth"){
					Ext.Msg.show({title:'提示',msg:'当前战略的当前月份丢失,程序终止!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			}
		},
		scope: this
	});
}*/

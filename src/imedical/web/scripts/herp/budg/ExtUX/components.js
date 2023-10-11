// /名称: 常用组件的简单封装
// /描述: 常用组件的简单封装
// /编写者：zhangdongmei
// /编写日期: 2012.12.27

Ext.ns("Ext.ux");
    
//供应商
Ext.ux.VendorComboBox=Ext.extend(Ext.form.ComboBox,{
	fieldLabel : '供应商',
	anchor : '90%',
	valueField : 'RowId',
	displayField : 'Description',
	emptyText : '供应商...',
	selectOnFocus : true,
	minChars : 3,
	typeAhead:false,
	pageSize : 20,
	listWidth : 250,
	valueNotFoundText : '',
	forceSelection : true,
	initComponent:function(){
		this.store=new Ext.data.JsonStore({
			autoDestroy:true,
			url:DictUrl+ 'orgutil.csp?actiontype=APCVendor&APCType='+App_StkTypeCode,
			storeId:'VendorStore',
			idProperty:'RowId',
			root:'rows',
			totalProperty:'results',
			fields:['RowId','Description'],
			baseParams:{
				filter:''
			}
		});
		
		this.on('beforequery',function(e){
			var filter=this.getRawValue();
			this.store.removeAll();    //load之前remove原记录，否则容易出错
			this.store.setBaseParam("filter",filter);
			this.store.load({params:{start:0,limit:20}});
		});
		Ext.ux.VendorComboBox.superclass.initComponent.call(this);
	}
});

//供应商应用中的供应商
Ext.ux.UsrVendorComboBox=Ext.extend(Ext.form.ComboBox,{
	fieldLabel : '供应商',
	anchor : '90%',
	valueField : 'RowId',
	displayField : 'Description',
	emptyText : '供应商...',
	selectOnFocus : true,
	minChars : 3,
	typeAhead:false,
	pageSize : 20,
	listWidth : 250,
	valueNotFoundText : '',
	userId :null,    //新增属性，登录人员id
	//editable : false,
	initComponent:function(){
		var myUrl=""
		if (this.userId!=null && this.userId!=""){
			myUrl=DictUrl+ 'orgutil.csp?actiontype=VendorbyUsr&APCType='+App_StkTypeCode+'&VUser='+this.userId;
		}
		this.store=new Ext.data.JsonStore({
			autoDestroy:true,			
			url:myUrl,		
			storeId:'UsrVendorStore',
			idProperty:'RowId',
			root:'rows',
			totalProperty:'results',
			fields:['RowId','Description'],
			baseParams:{
				filter:''
			}
		});
		this.on('beforequery',function(e){
			var filter=this.getRawValue();
			this.store.removeAll();    //load之前remove原记录，否则容易出错
			this.store.setBaseParam("filter",filter);
			this.store.load({params:{start:0,limit:20}});
			
		});
		var me=this;
		this.store.on('load', function(store,records,opt){ 
			if(records.length==1){
					var rowid= records[0].get('RowId');
					var desc=records[0].get('Description');
					me.setValue(rowid);
					
			}
 			
		}); 
		
		Ext.ux.UsrVendorComboBox.superclass.initComponent.call(this);
		this.store.load();
	}
});

//科室：如果设置了groupId属性，装载安全组能访问的科室，否则装载所有科室
Ext.ux.LocComboBox=Ext.extend(Ext.form.ComboBox,{
	fieldLabel : '科室',
	anchor : '90%',
	valueField : 'RowId',
	displayField : 'Description',
	//allowBlank : true,
	//triggerAction : 'query',
	//===================
	forceSelection : true,// 值为true时将限定选中的值为列表中的值，值为false则允许用户将任意文本设置到字段（默认为 false）。
	//====================
	emptyText : '科室...',
	selectOnFocus : true,
	//forceSelection : true,
	minChars : 3,
	pageSize : 20,
	listWidth : 250,
	typeAhead:false,
	valueNotFoundText : '',
	//mode:'local',
	groupId:null,    //新增属性，安全组id
	defaultLoc:null,  //新增属性，默认科室,"",不设置默认科室;{RowId:ctloc_rowid,Description:ctloc_desc}设置默认科室为指定值，如果默认科室为登陆科室，不需设置该属性
	initComponent:function(){
		var myUrl="";
		if (this.groupId==null || this.groupId==""){
			myUrl=DictUrl+ 'orgutil.csp?actiontype=DeptLoc';
		}else{
			myUrl=DictUrl+ 'orgutil.csp?actiontype=GetGroupDept';
		}
		//指定store
		this.store=new Ext.data.JsonStore({
			autoDestroy:true,
			url:myUrl,
			storeId:'LocStore',
			idProperty:'RowId',
			root:'rows',
			totalProperty:'results',
			fields:['RowId','Description'],
			baseParams:{
				groupId:this.groupId,
				locDesc:''
			}
		});
		//增加事件监听：根据录入的内容装载store
		this.on('beforequery',function(e){
			this.store.removeAll();    //load之前remove原记录，否则容易出错
			var filter=this.getRawValue();
			this.store.setBaseParam("locDesc",filter);
			this.store.load({params:{start:0,limit:this.pageSize}});
		});
		
		//设置默认值
		var defaultData=this.defaultLoc;
		
		if(this.defaultLoc==null){
			// 设置当前登录科室为默认值
			var rowId = session['LOGON.CTLOCID'];
			defaultData = {
				RowId : rowId,
				Description : App_LogonLocDesc
			};			
		}
		if(defaultData!=""){
			var record = new this.store.recordType(defaultData);
			var rowId=record.get('RowId');
			this.store.add(record);
			this.setValue(rowId);
		}
		Ext.ux.LocComboBox.superclass.initComponent.call(this);
	},
	setDefLoc:function(loc){
		this.defaultLoc=loc;
	},
	setGroupId:function(grp){
		this.store.removeAll();
		this.groupId=grp;
		
		var myUrl="";
		if (this.groupId==null || this.groupId==""){
			myUrl=DictUrl+ 'orgutil.csp?actiontype=DeptLoc';
		}else{
			myUrl=DictUrl+ 'orgutil.csp?actiontype=GetGroupDept';
		}
		//指定store
		this.store=new Ext.data.JsonStore({
			autoDestroy:true,
			url:myUrl,
			storeId:'LocStore',
			idProperty:'RowId',
			root:'rows',
			totalProperty:'results',
			fields:['RowId','Description'],
			baseParams:{
				groupId:this.groupId,
				locDesc:''
			}
		});
		//增加事件监听：根据录入的内容装载store
		this.on('beforequery',function(e){
			this.store.removeAll();    //load之前remove原记录，否则容易出错
			var filter=this.getRawValue();
			this.store.setBaseParam("locDesc",filter);
			this.store.load({params:{start:0,limit:this.pageSize}});
		});
		
		var defLoc=this.defaultLoc;
		var cb=this;
		this.store.on('load',function(ds){
			if (ds.getCount()>0){			
				cb.setValue(defLoc);
			}	
		});
		
		this.store.removeAll();  
		this.store.load({params:{start:0,limit:this.pageSize}});
	}
});

//封装的combox控件
Ext.ux.ComboBox=Ext.extend(Ext.form.ComboBox,{
	anchor : '90%',
	selectOnFocus : true,
	minChars : 3,
	pageSize : 20,
	listWidth : 250,
	typeAhead:false,
	valueNotFoundText : '',
	emptyText:'',
	filterName:'',      //store定义的根据录入内容过滤数据的参数名称
	params:null,      //其它参数{参数名称:提供参数值的控件id}
	valueParams:null,	//参数{参数名称:参数值}
	initComponent:function(){
		//增加事件监听：根据录入的内容装载store
		this.on('beforequery',function(e){
			this.store.removeAll();    //load之前remove原记录，否则容易出错
			var filter=this.getRawValue();
			if(this.filterName!=""){
				this.store.setBaseParam(this.filterName,filter);				
			}
			for(param in this.params){
				var value=Ext.getCmp(this.params[param]).getValue();
				this.store.setBaseParam(param,value);
			}
			for(param in this.valueParams){
				this.store.setBaseParam(param,this.valueParams[param]);
			}
			this.store.load({params:{start:0,limit:20}});
		});
		
		Ext.ux.ComboBox.superclass.initComponent.call(this);
	}
});
/*
 Ext.form.ComboBox.prototype.initQuery = Ext.form.ComboBox.prototype.initQuery.createInterceptor(function(e)
    {
        var v = this.getRawValue();
        
        if (typeof v === 'undefined' || v === null || v === '')
            this.clearValue();
    });
 * */
// 消息管理
Msg = {};
// 显示消息
Msg.show = function(type, msg) {
	var title, icon;
	switch (type) {
		case 'error' :
			title = "错误信息";
			icon = Ext.MessageBox.ERROR;
			break;
		case 'warn' :
			title = "警告信息";
			icon = Ext.MessageBox.WARNING;
			break;
		default :
			title = '提示信息';
			icon = Ext.MessageBox.INFO;
	}
	Ext.Msg.show({
				title : title,
				msg : msg,
				buttons : Ext.Msg.OK,
				icon : icon
			});
};
// 显示消息
Msg.flashshow = function(type,msg) {
	Ext.ux.Msg.flash({
		 msg: msg,
		time: 1,
		type: type
		});
};
// 错误信息显示
Msg.error = function(message) {
	Msg.show('error', message);
};

// 警告信息显示
Msg.warn = function(message) {
	Msg.show('warn', message);
};

// 信息显示
Msg.info = function(type,message) {
	//Msg.show('info', message);
	Msg.flashshow(type,message);
};


Msg.delConfirm = function(msg, fn) {
	/*
	if (Ext.type(msg) == "function") {
		fn = msg, msg = null;
	}
	var message = msg || "删除时不可逆的,您确认要删除吗?";
	Ext.Msg.confirm("确认删除", "您确定删除选中的记录吗？", function(btn, txt) {
				if (btn == "yes") {
					fn.apply(window);
				}
			});
			*/
};

//ComboBox in an Editor Grid: create reusable renderer
//适用于渲染时combobox中数据已装载的情况
Ext.util.Format.comboRenderer = function(combo){
    return function(value){    	
        var record = combo.findRecord(combo.valueField, value);
        return record ? record.get(combo.displayField) : combo.valueNotFoundText;
    }
}

/*
 2012-09-06,zhangdongmei,渲染grid中combox,适用于渲染时下拉框中没有数据的情况
 combo：下拉框
 valuefield:record中对应的下拉框的rowid字段名,
 displaytext:record中对应的下拉框的displayText字段名,
 displaytext2:record中对应的下拉框的displayText字段名(用于displayText是由record中两个字段组成的情况),
 */
Ext.util.Format.comboRenderer2 = function(combo,valuefield,displaytext,displaytext2){
    return function(value, metaData, record, rowIndex, colIndex, store){
    	
    	if(value==null|| value==""){
    		return combo.valueNotFoundText;
    	}
    	var text="";
    	var rowid="";
    	if(record){
	    	rowid=record.get(valuefield);
			text=record.get(displaytext);
			if(displaytext2!=null & displaytext2!=""){				
				var text2=record.get(displaytext2);
				text=text+"~"+text2;
			}
		}
		var find = combo.findRecord(combo.valueField, value);
		if((find==null)&(text!="")){
			var comboxstore=combo.getStore();
			addComboData(comboxstore,rowid,text);
			find = combo.findRecord(combo.valueField, value);
		}
		//2013-12-05 add:给displaytext列赋值,否则界面取不到grid中combo列的描述
		if(find!=null){
			record.set(displaytext,find.get(combo.displayField));   
		}else{
			record.set(displaytext,""); 
		}
        //alert(find);
        return find ? find.get(combo.displayField) : combo.valueNotFoundText;
    }
}

/*
 2016-10-11,XiaoMing Liu,渲染grid中combox,适用于渲染时下拉框中没有数据的情况
 combo：下拉框
 valuefield:record中对应的下拉框的rowid字段名,
 displaytext:record中对应的下拉框的displayText字段名,
 displaytext2:record中对应的下拉框的displayText字段名(用于displayText是由record中两个字段组成的情况),
 */
Ext.util.Format.comboRenderer3 = function(combo,valuefield,displaytext,displaytext2){
    return function(value, metaData, record, rowIndex, colIndex, store){
    	
    	if(value==null|| value==""){
    		return combo.valueNotFoundText;
    	}
    	var text="";
    	var rowid="";
    	if(record){
	    	rowid=record.get(valuefield);
			text=record.get(displaytext);
			if(displaytext2!=null & displaytext2!=""){				
				var text2=record.get(displaytext2);
				text=text+"~"+text2;
			}
		}
		var find = combo.findRecord(combo.valueField, value);
		if((find==null)&(text!="")){
			var comboxstore=combo.getStore();
			addComboData2(comboxstore,rowid,text);
			find = combo.findRecord(combo.valueField, value);
		}
		//2013-12-05 add:给displaytext列赋值,否则界面取不到grid中combo列的描述
		if(find!=null){
			record.set(displaytext,find.get(combo.displayField));   
		}else{
			record.set(displaytext,""); 
		}
        //alert(find);
        return find ? find.get(combo.displayField) : combo.valueNotFoundText;
    }
}

//封装日期型字段
Ext.ux.EditDate=Ext.extend( Ext.form.DateField,{
	format : 'Y-m-d',
	value : new Date(),
	listeners:{
		'specialkey':function(d,e){
			if (e.getKey()==13){
				var s=d.getRawValue();
				var dd=getCalDate(s);
				if (dd==''){d.setValue('');}
				else
				{d.setRawValue(dd ) ;}
			}
		},
		'blur':function(d)
		{
			var s=d.getRawValue();
			var dd=getCalDate(s);
			if (dd==''){d.setValue('');}
			else
			{d.setRawValue(dd ) ;}	
		}
	}
});


Ext.ux.DateField=Ext.extend(Ext.form.DateField,{
	anchor : '90%',
	format:'Y-m-d',
	altFormats:'j|d|ym|ymd|Ymd'+'|Y-m|Y-n|y-m|y-n'+'|Y-m-d|Y-m-j|Y-n-d|Y-n-j|y-m-d|y-m-j|y-n-d|y-n-j',
	invalidClass:'',
	invalidText:'',
	regex:/^(t|(t[\+\-]\d*)|\d{1,2}|\d{4}|\d{6}|\d{8}|(\d{4}\-\d{2}\-\d{2}))$/,
	regexText:'请输入正确的日期格式!',
	initComponent:function(){
		this.on('blur',function(e){
			var str=this.getRawValue();
			str=str.replace(/\s/g,"");
			if(str=="t"){
				this.setValue(new Date());
			}
			else if(str.indexOf("t+")==0 || str.indexOf("t-")==0){
				var addDayNum=parseInt(str.substring(2));
				if(isNaN(addDayNum)){
					this.setValue('');
				}else{
					if(addDayNum=="") {addDayNum=0;}
					if(str.substring(1,2)=="-"){
						addDayNum=-addDayNum;
					}
					this.setValue(new Date().add(Date.DAY, parseInt(addDayNum)));
				}
			}else{
				this.setValue(this.getValue());
			}
		});
		Ext.ux.DateField.superclass.initComponent.call(this);
	}
});
//根据输入的串计算得出日期
// T+xxx,t+xxx
// T-xxx,t-xxx
// "YYYYMMDD","YYMMDD","YYMM"
function getCalDate(dateStr)
{
    var validate_day;
    var ValidExpDate = "";    
    if (dateStr!= "") 
    {
        if (dateStr.trim().toUpperCase().substr(0,1) == "T")   
        {ValidExpDate = CreateDate(dateStr); }
        else
        {
        	//alert(dateStr);
        	//alert(isDate(dateStr));
        	
	        if  (isDate(dateStr)!='')  
	        	{ValidExpDate = isDate(dateStr) ;  }
	        else {
	            switch (dateStr.length)
	            {
	                case 6:   
	                    validate_day = Get_DateS(dateStr);	                
	                    if  ( validate_day != "" )   {ValidExpDate = validate_day;  }	         
	                    break;	
	               case 8:
	                    validate_day = Get_DateS(dateStr);
	                    if  ( validate_day != "" )   {ValidExpDate = validate_day;  }	         
	                    break;		               	
	               case 4:
	                    validate_day = Get_DateS(dateStr);
	                    if  ( validate_day != "" )   {ValidExpDate = validate_day;  }	         
	                    break;	                
	               default:   	
						if  (isDate(dateStr)=="")  {ValidExpDate = "";}
						else { ValidExpDate = isDate(dateStr); }		
						break;
	            }
	  
	        }
    	}
    }
    return ValidExpDate;
}

//根据字符串计算得出日期串
function CreateDate(dateExpress)
{
    var i ;
    var offset_flag ;
    var resultDate="";
    var today=Date.parseDate(new Date().format('Y-m-d'),'Y-m-d');
    
    var dateExpress =dateExpress.trim();
    var dateLen = dateExpress.length;
    
    if (dateExpress.toUpperCase().substr(0,1) != "T" ) { resultDate = "";   }
    var tmps = dateExpress.trim().substr(1, dateLen - 1);
    
    offset_flag = tmps.substr(0,1);
    
    if ((offset_flag != "+")&&( offset_flag != "-")) {
        resultDate = today.format('Y-m-d');   }
    else
    {        
        var days = tmps.substr(1,tmps.length-1) ; 
        if (isNaN(days)) {days=0;}
        
        if  ( offset_flag == "+")  {resultDate =today.add(Date.DAY,parseFloat(days)).format('Y-m-d'); }
        else
        {  	resultDate =today.add(Date.DAY,parseFloat(-days)).format('Y-m-d'); } 

    }
	return resultDate;
}

//判断是否为合法的日期字符串
//是：返回字符串
//否：返回''
function isDate(s)
{
    var dt = Date.parseDate(s, "Y-m-d");
    if (dt) return dt.format('Y-m-d');
    
    var dt = Date.parseDate(s, "Y-n-d");
    if (dt) return dt.format('Y-m-d');
    
    var dt = Date.parseDate(s, "Y-m-j");
    if (dt) return dt.format('Y-m-d');
 
    var dt = Date.parseDate(s, "Y-n-j");
    if (dt) return dt.format('Y-m-d');
    
    return '';  
}

//'将传入值进行转换，返回日期字符串(YYYY-MM-DD)
//'必须是6位,8位,4位
function Get_DateS(s ) 
{

	var resultDateValue="";
    if (( s.length != 6) &&  (s.length != 8) && (s.length != 4 ) ) {
        resultDateValue = "";
    }
    var today=Date.parseDate(new Date().format('Y-m-d'),'Y-m-d');
    
    var yyyy;
    var mm;
    var dd;
    
    if  ( s.length == 8 ) {
        yyyy = s.substr(0, 4);
        mm = s.substr(4, 2) ;
        dd = s.substr(6, 2);
        
        if (dd == "") { 
        	dd = "01"  ;  //'未确定日期时用01代替
        }
                
        if ( isNaN(yyyy) ||  isNaN(mm) ||  isNaN(dd)) {
            resultDateValue = "";  }
        
        if (( parseFloat(yyyy) < 1900) ||  (parseFloat(yyyy) > 2999 )){
            resultDateValue = "";}
       
        if ((parseFloat(mm) > 12) || ( parseFloat(mm) <= 0) ) {
            resultDateValue = "";           
        }
            
        if  (isDate(yyyy + "-" + mm + "-" + dd)=="") {
            resultDateValue = "";           
        }
        else        		{
            resultDateValue = String.leftPad(yyyy,4,'0') + "-" + String.leftPad(mm,2,'0') + "-" + String.leftPad(dd,2,'0');
        }
        
    }
    
    if ( (s.length) == 6)
    {
        yyyy = s.substr(0,2);
    	mm = s.substr(2, 2);
		dd = s.substr( 4, 2);
        
        if  (dd == "") { 
        	dd = "01" ;  // '未确定日期时用01代替
        }
                
        if ( isNaN(yyyy) || isNaN(mm) ||  isNaN(dd)) {
            resultDateValue = "";  }
        
        yyyy =  today.format('Y').substr( 0, 2) + yyyy ;
        
        if  (parseFloat(yyyy) < 1900 || parseFloat(yyyy) > 2999 ) {
            resultDateValue = ""; 
        }
        
        if  (parseFloat(mm) > 12 || parseFloat(mm) <= 0) {
            resultDateValue = ""; }
            
        if ( isDate(yyyy + "-" + mm + "-" + dd)=="") {
            resultDateValue = "";    }
        
        resultDateValue = String.leftPad(yyyy,4,'0') + "-" + String.leftPad(mm,2,'0') + "-" + String.leftPad(dd,2,'0');     
    }
    
    
    if (s.length == 4 ) {
    
		yyyy = s.substr(0, 2);
		mm = s.substr(2, 2);
		yyyy=today.format('Y').substr(0,2) + yyyy;
		if ( (parseFloat(yyyy) < 1900) || (parseFloat(yyyy) > 2999 ) ) {
		    resultDateValue = ""   ;
		}
		var next_m ;
		var next_y ;
		var next_day;
		next_m = parseFloat(mm) + 1;
		next_y = yyyy;
		if ( next_m > 12) {
			next_m = '01';
			next_y = parseFloat(yyyy) + 1;
		}
		next_day = String.leftPad(next_y,4,'0') + "-"  + String.leftPad(next_m,2,'0') + "-01";

		var dd=isDate(next_day);
	
		if (dd!='')
		{
			var d=Date.parseDate(dd,'Y-m-d')	;
			
			var ddd =d.add(Date.DAY,-1) ;
			resultDateValue =ddd.format('Y-m-d');
		}
		else
		{resultDateValue='';}          
    }
    return resultDateValue;
}

///封装GridPanel和EditorGridpanel, 实现列设置功能
Ext.ux.GridPanel = Ext.extend(Ext.grid.GridPanel,{
	listeners:{
		containerdblclick : function(grid,e){
			if(typeof(gAppName)=='undefined'){
				return;
			}
			GridColSet(grid,gAppName);
		},
		beforerender : function(grid){
			if(typeof(gAppName)=='undefined'){
				return;
			}
			RefreshGridColSet(grid,gAppName);
		}
	}
});

Ext.ux.EditorGridPanel = Ext.extend(Ext.grid.EditorGridPanel,{
	listeners:{
		containerdblclick : function(grid,e){
			if(typeof(gAppName)=='undefined'){
				return;
			}
			GridColSet(grid,gAppName);
		},
		beforerender : function(grid){
			if(typeof(gAppName)=='undefined'){
				return;
			}
			RefreshGridColSet(grid,gAppName);
		}
	}
});
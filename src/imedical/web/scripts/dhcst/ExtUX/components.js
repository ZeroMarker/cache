// /名称: 常用组件的简单封装
// /描述: 常用组件的简单封装
// /编写者：zhangdongmei
// /编写日期: 2012.12.27

Ext.ns("Ext.ux");
Ext.apply(Ext.form.ComboBox.prototype,{
    onLoad: function() {
        if (!this.hasFocus) {
            return;
        }
        if (this.store.getCount() > 0 || this.listEmptyText) {
            this.expand();
            this.restrictHeight();
            if (this.lastQuery == this.allQuery) {
                if (this.editable) {
                    this.el.dom.select();
                }

                if (this.autoSelect !== false && !this.selectByValue(this.value, true)) {
                    this.select(0, true);
                }
            } else {
                if (this.autoSelect !== false) {
	                this.select(0, true); //默认首行有问题
                    //this.selectNext();
                }
                if (this.typeAhead && this.lastKey != Ext.EventObject.BACKSPACE && this.lastKey != Ext.EventObject.DELETE) {
                    this.taTask.delay(this.typeAheadDelay);
                }
            }
        } else {
            this.collapse();
        }

    }
});
//经营企业
Ext.ux.VendorComboBox=Ext.extend(Ext.form.ComboBox,{
	fieldLabel : $g('经营企业'),
	anchor : '90%',
	valueField : 'RowId',
	displayField : 'Description',
	emptyText : $g('经营企业...'),
	selectOnFocus : true,
	minChars : 3,
	typeAhead:false,
	pageSize : 20,
	listWidth : 250,
	valueNotFoundText : '',
	forceSelection : true,
	hospId:session['LOGON.HOSPID'], 
	initComponent:function(){
		this.store=new Ext.data.JsonStore({
			autoDestroy:true,
			url:DictUrl+ 'orgutil.csp?actiontype=APCVendor',
			storeId:'VendorStore',
			idProperty:'RowId',
			root:'rows',
			totalProperty:'results',
			fields:['RowId','Description'],
			baseParams:{
				filter:'',
				hospId:this.hospId
			}
		});
		
		this.on('beforequery',function(e){
			var filter=this.getRawValue();
			this.store.removeAll();    //load之前remove原记录，否则容易出错
			this.store.setBaseParam("filter",filter);
			this.store.setBaseParam("hospId",session['LOGON.HOSPID']);
			this.store.load({params:{start:0,limit:20}});
		});
		Ext.ux.VendorComboBox.superclass.initComponent.call(this);
	}
});

//科室：如果设置了groupId属性，装载安全组能访问的科室，否则装载所有科室
Ext.ux.LocComboBox=Ext.extend(Ext.form.ComboBox,{
	fieldLabel : $g('科室'),
	anchor : '90%',
	valueField : 'RowId',
	displayField : 'Description',
	//allowBlank : true,
	//triggerAction : 'query',
	//===================
	forceSelection : true,// 值为true时将限定选中的值为列表中的值，值为false则允许用户将任意文本设置到字段（默认为 false）。
	//====================
	emptyText : $g('科室...'),
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
	protype:null,
	relid:null,
	params:null,
	initComponent:function(){
		var myUrl="";
		if ((this.protype=="R")||(this.protype=="T")){
			myUrl=DictUrl+ 'locrelaction.csp?actiontype=GetRelLoc&relid='+this.relid+'&reltype='+this.protype;
		}else if ((this.protype=="TR")||(this.protype=="RF")){
		//if ((this.protype=="R")||(this.protype=="T")){
			if(this.protype=="TR"){
				var ptype="";
			}else{
				var ptype="R";
			}
			myUrl=DictUrl+ 'locrelaction.csp?actiontype=GetProRelLoc&relid='+this.relid+'&reltype='+ptype;
		}else if (this.groupId==null || this.groupId==""){
			myUrl=DictUrl+ 'orgutil.csp?actiontype=DeptLoc';
		}else{
			myUrl=DictUrl+ 'orgutil.csp?actiontype=GetGroupDept';
		}
		//if (this.groupId==null || this.groupId==""){
		//	myUrl=DictUrl+ 'orgutil.csp?actiontype=DeptLoc';
		//}else{
		//	myUrl=DictUrl+ 'orgutil.csp?actiontype=GetGroupDept';
		//}
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
			for(param in this.params){
				var value=Ext.getCmp(this.params[param]).getValue();
				this.store.setBaseParam(param,value);
			}
			this.store.load({params:{start:0,limit:20}});
		});
		
		//设置默认值
		var defaultData=this.defaultLoc;
		
		if(this.defaultLoc==null){
			// 设置当前登录科室为默认值
			var rowId = session['LOGON.CTLOCID'];
//			var arr = window.status.split(":");
//			var length = arr.length;
//			var name = arr[length-1].trim();
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
	}
});
//煎药是人员combobox
Ext.ux.MBCUserComboBox=Ext.extend(Ext.form.ComboBox,{
	fieldLabel : $g('操作人'),
	anchor : '90%',
	valueField : 'RowId',
	displayField : 'Description',
	//allowBlank : true,
	//triggerAction : 'query',
	//===================
	forceSelection : true,// 值为true时将限定选中的值为列表中的值，值为false则允许用户将任意文本设置到字段（默认为 false）。
	//====================
	emptyText : $g('操作人...'),
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
			myUrl=DictUrl+ 'orgutil.csp?actiontype=GroupMBCUser';
	
		//指定store
		this.store=new Ext.data.JsonStore({
			autoDestroy:true,
			url:myUrl,
			storeId:'MBCUserStore',
			idProperty:'RowId',
			root:'rows',
			totalProperty:'results',
			fields:['RowId','Description'],
			baseParams:{
				GrpDesc:$g('煎药'),
				mbcdesc:''
			} 
		});
		//增加事件监听：根据录入的内容装载store
		this.on('beforequery',function(e){
			this.store.removeAll();    //load之前remove原记录，否则容易出错
			var filter=this.getRawValue();
			this.store.setBaseParam("mbcdesc",filter);
			this.store.load({params:{start:0,limit:999}});
		});

		Ext.ux.MBCUserComboBox.superclass.initComponent.call(this);
	}
});
//封装的combox控件
Ext.ux.ComboBox=Ext.extend(Ext.form.ComboBox,{
	anchor : '90%',
	selectOnFocus : true,
	minChars : 3,
	pageSize : 20,
	listWidth : 250,
	//typeAhead:false,
	valueNotFoundText : '',
	emptyText:'',
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'',      //store定义的根据录入内容过滤数据的参数名称
	params:null,      //其它参数{参数名称:提供参数值的控件id}
	initComponent:function(){
		//增加事件监听：根据录入的内容装载store
		this.on('beforequery',function(e){
			//alert(1)
			this.store.removeAll();    //load之前remove原记录，否则容易出错
			var filter=this.getRawValue();
			if(this.filterName!=""){
				this.store.setBaseParam(this.filterName,filter);				
			}
			for(param in this.params){
				var value=Ext.getCmp(this.params[param]).getValue();
				this.store.setBaseParam(param,value);
			}
			this.store.load({params:{start:0,limit:20}});
		});
		
		Ext.ux.ComboBox.superclass.initComponent.call(this);
	}
});
//封装的comboxd控件 //add wyx 2014-04-28 传入的参数不用在取value。直接传入
Ext.ux.ComboBoxD=Ext.extend(Ext.form.ComboBox,{
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
	initComponent:function(){
		//增加事件监听：根据录入的内容装载store
		this.on('beforequery',function(e){
			this.store.removeAll();    //load之前remove原记录，否则容易出错
			var filter=this.getRawValue();
			if(this.filterName!=""){
				this.store.setBaseParam(this.filterName,filter);				
			}
			for(param in this.params){
				//var value=Ext.getCmp(this.params[param]).getValue();
				var value=this.params[param];
				this.store.setBaseParam(param,value);
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
			title = $g("错误信息");
			icon = Ext.MessageBox.ERROR;
			break;
		case 'warn' :
			title = $g("警告信息");
			icon = Ext.MessageBox.WARNING;
			break;
		default :
			title = $g('提示信息');
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

		if (find!=null)  //给displaytext 列赋值,否界面取不到grid中combo列的描述 LiangQiang 2013-11-26
		{
			record.set(displaytext,find.get(combo.displayField));   
		}else
		{
			record.set(displaytext,""); 
		}
        //alert(find);
        return find ? find.get(combo.displayField) : combo.valueNotFoundText;
    }
}
Ext.ux.DateField=Ext.extend(Ext.form.DateField,{
	anchor : '90%',
	invalidClass:'',
	invalidText:'',
	regexText:$g('请输入正确的日期格式!'),
	initComponent:function(){
		var altFormats = 'j|d|md|ymd|Ymd'+'|Y-m|Y-n|y-m|y-n'+'|Y-m-d|Y-m-j|Y-n-d|Y-n-j|y-m-d|y-m-j|y-n-d|y-n-j';
		var regex = /^(t|(t[\+\-]\d*)|\d{1,2}|\d{4}|\d{6}|\d{8}|((\d{4}|\d{2})\-\d{1,2}\-\d{1,2}))$/;
		if(this.format == 'm/d/Y'){
			altFormats = 'j|d|md|mdy|mdY'+'|n/j|n/d|m/j|m/d'+'|n/j/y|n/j/Y|n/d/y|n/d/Y|m/j/y|m/j/Y|m/d/y|m/d/Y';
			regex = /^(t|(t[\+\-]\d*)|\d{1,2}|\d{4}|\d{6}|\d{8}|(\d{1,2}\/\d{1,2}\/(\d{4}|\d{2})))$/;
		}else if(this.format == 'd/m/Y'){
			altFormats = 'j|d|dm|dmy|dmY'+'|j/n|j/m|d/n|d/m'+'|j/n/y|j/n/Y|j/m/y|j/m/Y|d/n/y|d/n/Y|d/m/y|d/m/Y';
			regex = /^(t|(t[\+\-]\d*)|\d{1,2}|\d{4}|\d{6}|\d{8}|(\d{1,2}\/\d{1,2}\/(\d{4}|\d{2})))$/;
		}else if(this.format == 'j/n/Y'){
			altFormats = 'j|d|dm|dmy|dmY'+'|j/n|j/m|d/n|d/m'+'|j/n/y|j/n/Y|j/m/y|j/m/Y|d/n/y|d/n/Y|d/m/y|j/n/Y';
			regex = /^(t|(t[\+\-]\d*)|\d{1,2}|\d{4}|\d{6}|\d{8}|(\d{1,2}\/\d{1,2}\/(\d{4}|\d{2})))$/;
		}
		this.altFormats = altFormats;
		this.regex = regex;
		this.on('blur',function(e){
			var str=this.getRawValue();
			str=str.replace(/\s/g,"").toLowerCase();
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
		this.on('specialkey',function(field,e){
			if (e.getKey() == Ext.EventObject.ENTER){
				this.fireEvent('blur');
			}
		});
		Ext.ux.DateField.superclass.initComponent.call(this);
	},
	/*
	 * 重写DateField的parseDate方法,对于6位数字格式化进行特殊处理
	 */
	parseDate : function(value) {
		if(!value || Ext.isDate(value)){
			return value;
		}
		var v = this.safeParse(value, this.format),
			af = this.altFormats,
			afa = this.altFormatsArray;
		if (!v && af) {
			afa = afa || af.split("|");
			for (var i = 0, len = afa.length; i < len && !v; i++) {
				if(afa[i] == 'ymd' && Ext.isString(value) && (Number(value) == value) && value.length == 6 && value.substring(2,4) > 12){
					//该if内为特殊处理部分, 形如201609(第3,4为>12)取该月最后一天,即20160930
					var firstDay = Date.parseDate(value + '01', 'Ymd');
					v = firstDay.getLastDateOfMonth();
				}else{
					v = this.safeParse(value, afa[i]);
				}
			}
		}
		return v;
	}
});
Ext.reg('uxdatefield',Ext.ux.DateField);

//封装日期型字段
Ext.ux.EditDate=Ext.extend( Ext.form.DateField,{
	//format : 'Y-m-d',
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
    
    var dt = Date.parseDate(s, "d/m/Y");
    if (dt) return dt.format('d/m/Y');
    
    var dt = Date.parseDate(s, "j/n/Y");
    if (dt) return dt.format('d/m/Y');
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



//经营企业
Ext.ux.VendorComboBox=Ext.extend(Ext.form.ComboBox,{
	fieldLabel : $g('经营企业'),
	anchor : '90%',
	valueField : 'RowId',
	displayField : 'Description',
	emptyText : $g('经营企业...'),
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
			url:DictUrl+ 'orgutil.csp?actiontype=APCVendor',
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

	 

//招标
Ext.ux.ZBComboBox=Ext.extend(Ext.form.ComboBox,{
	fieldLabel : $g('是否招标'),
	anchor : '90%',
	valueField : 'rowid',
	displayField : 'desc',
	emptyText : $g('是否招标...'),
	selectOnFocus : true,
	mode: 'local',
	forceSelection : true,
	initComponent:function(){
		
		this.store=new Ext.data.SimpleStore({
		fields: ['desc', 'rowid'],
		data : [[$g('全部'),'1'],[$g('招标'),'2'],[$g('非招标'),'3']]
		});
		Ext.ux.ZBComboBox.superclass.initComponent.call(this);
	}
});



//科室：装载所有药房科室
Ext.ux.DispLocComboBox=Ext.extend(Ext.form.ComboBox,{
	fieldLabel : $g('药房科室'),
	anchor : '90%',
	valueField : 'RowId',
	displayField : 'Description',
	//allowBlank : true,
	//triggerAction : 'query',
	//===================
	forceSelection : true,// 值为true时将限定选中的值为列表中的值，值为false则允许用户将任意文本设置到字段（默认为 false）。
	//====================
	emptyText : $g('科室...'),
	selectOnFocus : true,
	//forceSelection : true,
	minChars : 3,
	pageSize : 20,
	listWidth : 250,
	typeAhead:false,
	valueNotFoundText : '',
	initComponent:function(){
		var myUrl="";
		myUrl=DictUrl+ 'orgutil.csp?actiontype=PhaDept';
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
			this.store.load({params:{start:0,limit:20}});
		});
		

		Ext.ux.DispLocComboBox.superclass.initComponent.call(this);
	}
});

//科室：装载所有执行科室
Ext.ux.ExeLocComboBox=Ext.extend(Ext.form.ComboBox,{
	fieldLabel : $g('执行科室'),
	anchor : '90%',
	valueField : 'RowId',
	displayField : 'Description',
	//allowBlank : true,
	//triggerAction : 'query',
	//===================
	forceSelection : true,// 值为true时将限定选中的值为列表中的值，值为false则允许用户将任意文本设置到字段（默认为 false）。
	//====================
	emptyText : $g('科室...'),
	selectOnFocus : true,
	//forceSelection : true,
	minChars : 3,
	pageSize : 20,
	listWidth : 250,
	typeAhead:false,
	valueNotFoundText : '',
	initComponent:function(){
		var myUrl="";
		myUrl=DictUrl+ 'orgutil.csp?actiontype=ExeDept';
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
			this.store.load({params:{start:0,limit:20}});
		});
		

		Ext.ux.ExeLocComboBox.superclass.initComponent.call(this);
	}
});
//病区
Ext.ux.LocWardComboBox=Ext.extend(Ext.form.ComboBox,{
	fieldLabel : $g('病区'),
	anchor : '90%',
	valueField : 'RowId',
	displayField : 'Description',
	emptyText : $g('病区...'),
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
			url:DictUrl+ 'orgutil.csp?actiontype=GetLocWard',
			storeId:'LocWardStore',
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
		Ext.ux.LocWardComboBox.superclass.initComponent.call(this);
	 }
	});
	
 //发药类别
 Ext.ux.DispTypeComboBox=Ext.extend(Ext.form.ComboBox,{
	fieldLabel : $g('发药类别'),
	anchor : '90%',
	valueField : 'Type',
	displayField : 'Description',
	emptyText : $g('分类...'),
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
			url:DictUrl+ 'orgutil.csp?actiontype=GetDispType',
			storeId:'DispTypeStore',
			idProperty:'Type',
			root:'rows',
			totalProperty:'results',
			fields:['Type','Description'],
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
		Ext.ux.DispTypeComboBox.superclass.initComponent.call(this);
	}

});	
//获取医生集合
Ext.ux.DoctorDsComboBox=Ext.extend(Ext.form.ComboBox,{
	fieldLabel : $g('医生'),
	anchor : '90%',
	valueField : 'RowId',
	displayField : 'Description',
	emptyText : $g('医生...'),
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
			url:DictUrl+ 'orgutil.csp?actiontype=GetDoctorDs',
			storeId:'DoctorDsStore',
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
		Ext.ux.DoctorDsComboBox.superclass.initComponent.call(this);
	 }
	});
/** 
 * 右下角的提醒窗口
 * @author warnx.javaeye.com
 * @params conf 参考Ext.Window
 *         conf中添加autoHide配置项, 默认3秒自动隐藏, 设置自动隐藏的时间(单位:秒), 不需要自动隐藏时设置为false
 * @注: 使用独立的window管理组(manager:new Ext.WindowGroup()), 达到总是显示在最前的效果
 */

Ext.ux.WarnsWindow = Ext.extend(Ext.Window,
    {
        width: 220,
        height: 165,
        layout: 'fit',
        modal: false,
        plain: false,
        shadow: false,
        //去除阴影
        draggable: true,
        //默认不可拖拽
        resizable: false,
        closable: true,
        closeAction: 'hide',
        autoScroll: true,
        autoDestroy: true,
        //默认关闭为隐藏
        autoHide: 3,
        count:1,//设置显示的是第几个warnwindow
        //n秒后自动隐藏，为false时,不自动隐藏
        manager: new Ext.WindowGroup({
        	zseed:99999
        	}),
        //设置window所属的组
        constructor: function(conf)
        {
            Ext.ux.WarnsWindow.superclass.constructor.call(this, conf);
            this.initPosition(true);
        },
        initEvents: function()
        {
           Ext.ux.WarnsWindow.superclass.initEvents.call(this);
            //自动隐藏
            if (false !== this.autoHide)
            {
                var task = new Ext.util.DelayedTask(this.hide, this),
                second = (parseInt(this.autoHide) || 3) * 1000;
                this.on('beforeshow',
                function(self)
                {
                    task.delay(second);
                });
            }
            this.on('beforeshow', this.showWarns);
            this.on('beforehide', this.hideWarns);

            Ext.EventManager.onWindowResize(this.initPosition, this); //window大小改变时，重新设置坐标
            Ext.EventManager.on(window, 'scroll', this.initPosition, this); //window移动滚动条时，重新设置坐标
        },
        //参数: flag - true时强制更新位置
        initPosition: function(flag)
        {
            if (true !== flag && this.hidden)
            { //不可见时，不调整坐标
                return false;
            }
            var doc = document,
            bd = (doc.body || doc.documentElement);
            //ext取可视范围宽高(与上面方法取的值相同), 加上滚动坐标
            var left = bd.scrollLeft + Ext.lib.Dom.getViewWidth() - 4 - this.width;
            var top = bd.scrollTop + Ext.lib.Dom.getViewHeight() - 4 - this.height*this.count;
            this.setPosition(left, top);
        },
        showWarns: function()
        {
            var self = this;
            if (!self.hidden)
            {
                return false;
            }

            self.initPosition(true); //初始化坐标
            self.el.slideIn('b',
            {
	            duration: 1,
                callback: function()
                {
                    //显示完成后,手动触发show事件,并将hidden属性设置false,否则将不能触发hide事件
                    self.fireEvent('show', self);
                    self.hidden = false;
                }
            });
            return false; //不执行默认的show
        },
        hideWarns: function()
        {
            var self = this;
            if (self.hidden)
            {
                return false;
            }

            self.el.slideOut('b',
            {
	            duration: 1,
                callback: function()
                {
                    //渐隐动作执行完成时,手动触发hide事件,并将hidden属性设置true
                    self.fireEvent('hide', self);
                    self.hidden = true;
                }
            });
            return false; //不执行默认的hide
        }
    });
/**
 * NumberField控件扩展,控制小数位数(decimalPrecision)
 * xtype : uxnumberfield
 * @class Ext.ux.NumberField
 * @extends Ext.form.NumberField
 */
Ext.ux.NumberField = Ext.extend(Ext.form.NumberField,{
	anchor : '90%',
	formatType : null,
	initComponent : function() {
		var myUrl = "";
		if(this.formatType != null){
			myUrl ='dhcst.extux.csp?actiontype=DecimalPresion&formatType=' + this.formatType;
			decimalLen = ExecuteDBSynAccess(myUrl);
			this.decimalPrecision = parseInt(decimalLen);
		}
		Ext.ux.NumberField.superclass.initComponent.call(this);
	}
	/*, 
    fixPrecision: function(value){  
        var nan = isNaN(value);  
        if (!this.allowDecimals || this.decimalPrecision == -1 || nan || !value) {  
            return nan ? '' : value;  
        }  
        return parseFloat(value).toFixed(this.decimalPrecision);  
    }*/
});
Ext.reg('uxnumberfield',Ext.ux.NumberField);

//医院：装载有授权的医院
Ext.ux.HospComboBox=Ext.extend(Ext.form.ComboBox,{
	fieldLabel : $g('医院'),
	anchor : '90%',
	valueField : 'RowId',
	displayField : 'Description',
	//===================
	forceSelection : true,// 值为true时将限定选中的值为列表中的值，值为false则允许用户将任意文本设置到字段（默认为 false）。
	//====================
	emptyText : $g('医院...'),
	selectOnFocus : false,
	minChars : 3,
	pageSize : 20,
	width : 300,
	listWidth : 300,
	typeAhead:false,
	valueNotFoundText : '',
	defaultHosp:null,  //新增属性，默认科室,"",不设置默认科室;{RowId:ctloc_rowid,Description:ctloc_desc}设置默认科室为指定值，如果默认科室为登陆科室，不需设置该属性
	tablename:null,
	dataid:null,
	params:null,
	stores:[], //选择医院时,需要根据医院重新加载数据的store
	grids:[], //选择医院时,需要清空数据的grid
	selHandler:null, //选中事件
	editable:false,   //是否允许编辑
	reloadStores:function(){
		var stores=this.stores;
		if((stores)&&(!(stores instanceof Array))){stores=[stores];}
		for(var ind=0;ind<stores.length;ind++)
		{
			store=stores[ind];
			store.removeAll();
			store.reload();
		}
	},
	clearGrids:function(){
		var grids=this.grids;
		if((grids)&&(!(grids instanceof Array))){grids=[grids];}
		for(var ind=0;ind<grids.length;ind++)
		{
			grid=grids[ind];
			grid.store.removeAll();
			grid.getView().refresh();
		}
	},
	initComponent:function(){
		var myUrl=myUrl=DictUrl+ 'orgutil.csp?actiontype=GetAuHospData';
		
		//指定store
		this.store=new Ext.data.JsonStore({
			autoDestroy:true,
			url:myUrl,
			storeId:'HospStore',
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
			//this.store.setBaseParam("FilterDesc",filter);   屏蔽模糊检索 2020-03-20 yangsj
			this.store.setBaseParam("tablename",this.tablename);
			this.store.setBaseParam("dataid",this.dataid);
			for(param in this.params){
				var value=Ext.getCmp(this.params[param]).getValue();
				this.store.setBaseParam(param,value);
			}
			this.store.load({params:{start:0,limit:20}});
		});
		
		//设置默认值
		var defaultData=this.defaultLoc;
		
		if(this.defaultLoc==null){
			// 设置当前登录科室为默认值
			var rowId = session['LOGON.HOSPID'];
			defaultData = {
				RowId : rowId,
				Description : App_LogonHospDesc
			};			
		}
		if(defaultData!=""){
			var record = new this.store.recordType(defaultData);
			var rowId=record.get('RowId');
			this.store.add(record);
			this.setValue(rowId);
		}
		//选择事件
		this.on(
			'select',function(combo,record,index){
			 	if(HospId!=this.value){
				 	HospId=this.value; //赋值给全局变量，保存、删除等程序使用;
				 	this.reloadStores();
				 	this.clearGrids();
				 	if(typeof this.selHandler === "function"){
					 	this.selHandler();
					 }
				}
			}
		);
		this.on(
			'blur',function(field){
				//为空时，默认成上一次选择的医院
				if(this.value==""){
					this.setValue(HospId); 
				}
			}
		);
		Ext.ux.HospComboBox.superclass.initComponent.call(this);
	}
});
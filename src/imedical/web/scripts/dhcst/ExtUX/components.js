// /����: ��������ļ򵥷�װ
// /����: ��������ļ򵥷�װ
// /��д�ߣ�zhangdongmei
// /��д����: 2012.12.27

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
	                this.select(0, true); //Ĭ������������
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
//��Ӫ��ҵ
Ext.ux.VendorComboBox=Ext.extend(Ext.form.ComboBox,{
	fieldLabel : $g('��Ӫ��ҵ'),
	anchor : '90%',
	valueField : 'RowId',
	displayField : 'Description',
	emptyText : $g('��Ӫ��ҵ...'),
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
			this.store.removeAll();    //load֮ǰremoveԭ��¼���������׳���
			this.store.setBaseParam("filter",filter);
			this.store.setBaseParam("hospId",session['LOGON.HOSPID']);
			this.store.load({params:{start:0,limit:20}});
		});
		Ext.ux.VendorComboBox.superclass.initComponent.call(this);
	}
});

//���ң����������groupId���ԣ�װ�ذ�ȫ���ܷ��ʵĿ��ң�����װ�����п���
Ext.ux.LocComboBox=Ext.extend(Ext.form.ComboBox,{
	fieldLabel : $g('����'),
	anchor : '90%',
	valueField : 'RowId',
	displayField : 'Description',
	//allowBlank : true,
	//triggerAction : 'query',
	//===================
	forceSelection : true,// ֵΪtrueʱ���޶�ѡ�е�ֵΪ�б��е�ֵ��ֵΪfalse�������û��������ı����õ��ֶΣ�Ĭ��Ϊ false����
	//====================
	emptyText : $g('����...'),
	selectOnFocus : true,
	//forceSelection : true,
	minChars : 3,
	pageSize : 20,
	listWidth : 250,
	typeAhead:false,
	valueNotFoundText : '',
	//mode:'local',
	groupId:null,    //�������ԣ���ȫ��id
	defaultLoc:null,  //�������ԣ�Ĭ�Ͽ���,"",������Ĭ�Ͽ���;{RowId:ctloc_rowid,Description:ctloc_desc}����Ĭ�Ͽ���Ϊָ��ֵ�����Ĭ�Ͽ���Ϊ��½���ң��������ø�����
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
		//ָ��store
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
		//�����¼�����������¼�������װ��store
		this.on('beforequery',function(e){
			this.store.removeAll();    //load֮ǰremoveԭ��¼���������׳���
			var filter=this.getRawValue();
			this.store.setBaseParam("locDesc",filter);
			for(param in this.params){
				var value=Ext.getCmp(this.params[param]).getValue();
				this.store.setBaseParam(param,value);
			}
			this.store.load({params:{start:0,limit:20}});
		});
		
		//����Ĭ��ֵ
		var defaultData=this.defaultLoc;
		
		if(this.defaultLoc==null){
			// ���õ�ǰ��¼����ΪĬ��ֵ
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
//��ҩ����Աcombobox
Ext.ux.MBCUserComboBox=Ext.extend(Ext.form.ComboBox,{
	fieldLabel : $g('������'),
	anchor : '90%',
	valueField : 'RowId',
	displayField : 'Description',
	//allowBlank : true,
	//triggerAction : 'query',
	//===================
	forceSelection : true,// ֵΪtrueʱ���޶�ѡ�е�ֵΪ�б��е�ֵ��ֵΪfalse�������û��������ı����õ��ֶΣ�Ĭ��Ϊ false����
	//====================
	emptyText : $g('������...'),
	selectOnFocus : true,
	//forceSelection : true,
	minChars : 3,
	pageSize : 20,
	listWidth : 250,
	typeAhead:false,
	valueNotFoundText : '',
	//mode:'local',
	groupId:null,    //�������ԣ���ȫ��id
	defaultLoc:null,  //�������ԣ�Ĭ�Ͽ���,"",������Ĭ�Ͽ���;{RowId:ctloc_rowid,Description:ctloc_desc}����Ĭ�Ͽ���Ϊָ��ֵ�����Ĭ�Ͽ���Ϊ��½���ң��������ø�����
	initComponent:function(){
		var myUrl="";
			myUrl=DictUrl+ 'orgutil.csp?actiontype=GroupMBCUser';
	
		//ָ��store
		this.store=new Ext.data.JsonStore({
			autoDestroy:true,
			url:myUrl,
			storeId:'MBCUserStore',
			idProperty:'RowId',
			root:'rows',
			totalProperty:'results',
			fields:['RowId','Description'],
			baseParams:{
				GrpDesc:$g('��ҩ'),
				mbcdesc:''
			} 
		});
		//�����¼�����������¼�������װ��store
		this.on('beforequery',function(e){
			this.store.removeAll();    //load֮ǰremoveԭ��¼���������׳���
			var filter=this.getRawValue();
			this.store.setBaseParam("mbcdesc",filter);
			this.store.load({params:{start:0,limit:999}});
		});

		Ext.ux.MBCUserComboBox.superclass.initComponent.call(this);
	}
});
//��װ��combox�ؼ�
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
	filterName:'',      //store����ĸ���¼�����ݹ������ݵĲ�������
	params:null,      //��������{��������:�ṩ����ֵ�Ŀؼ�id}
	initComponent:function(){
		//�����¼�����������¼�������װ��store
		this.on('beforequery',function(e){
			//alert(1)
			this.store.removeAll();    //load֮ǰremoveԭ��¼���������׳���
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
//��װ��comboxd�ؼ� //add wyx 2014-04-28 ����Ĳ���������ȡvalue��ֱ�Ӵ���
Ext.ux.ComboBoxD=Ext.extend(Ext.form.ComboBox,{
	anchor : '90%',
	selectOnFocus : true,
	minChars : 3,
	pageSize : 20,
	listWidth : 250,
	typeAhead:false,
	valueNotFoundText : '',
	emptyText:'',
	filterName:'',      //store����ĸ���¼�����ݹ������ݵĲ�������
	params:null,      //��������{��������:�ṩ����ֵ�Ŀؼ�id}
	initComponent:function(){
		//�����¼�����������¼�������װ��store
		this.on('beforequery',function(e){
			this.store.removeAll();    //load֮ǰremoveԭ��¼���������׳���
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
// ��Ϣ����
Msg = {};
// ��ʾ��Ϣ
Msg.show = function(type, msg) {
	var title, icon;
	switch (type) {
		case 'error' :
			title = $g("������Ϣ");
			icon = Ext.MessageBox.ERROR;
			break;
		case 'warn' :
			title = $g("������Ϣ");
			icon = Ext.MessageBox.WARNING;
			break;
		default :
			title = $g('��ʾ��Ϣ');
			icon = Ext.MessageBox.INFO;
	}
	Ext.Msg.show({
				title : title,
				msg : msg,
				buttons : Ext.Msg.OK,
				icon : icon
			});
};
// ��ʾ��Ϣ
Msg.flashshow = function(type,msg) {
	Ext.ux.Msg.flash({
		msg: msg,
		time: 1,
		type: type
	});
};
// ������Ϣ��ʾ
Msg.error = function(message) {
	Msg.show('error', message);
};

// ������Ϣ��ʾ
Msg.warn = function(message) {
	Msg.show('warn', message);
};

// ��Ϣ��ʾ
Msg.info = function(type,message) {
	//Msg.show('info', message);
	Msg.flashshow(type,message);
};


Msg.delConfirm = function(msg, fn) {
	/*
	if (Ext.type(msg) == "function") {
		fn = msg, msg = null;
	}
	var message = msg || "ɾ��ʱ�������,��ȷ��Ҫɾ����?";
	Ext.Msg.confirm("ȷ��ɾ��", "��ȷ��ɾ��ѡ�еļ�¼��", function(btn, txt) {
				if (btn == "yes") {
					fn.apply(window);
				}
			});
			*/
};

//ComboBox in an Editor Grid: create reusable renderer
//��������Ⱦʱcombobox��������װ�ص����
Ext.util.Format.comboRenderer = function(combo){
    return function(value){    	
        var record = combo.findRecord(combo.valueField, value);
        return record ? record.get(combo.displayField) : combo.valueNotFoundText;
    }
}

/*
 2012-09-06,zhangdongmei,��Ⱦgrid��combox,��������Ⱦʱ��������û�����ݵ����
 combo��������
 valuefield:record�ж�Ӧ���������rowid�ֶ���,
 displaytext:record�ж�Ӧ���������displayText�ֶ���,
 displaytext2:record�ж�Ӧ���������displayText�ֶ���(����displayText����record�������ֶ���ɵ����),
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

		if (find!=null)  //��displaytext �и�ֵ,�����ȡ����grid��combo�е����� LiangQiang 2013-11-26
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
	regexText:$g('��������ȷ�����ڸ�ʽ!'),
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
	 * ��дDateField��parseDate����,����6λ���ָ�ʽ���������⴦��
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
					//��if��Ϊ���⴦����, ����201609(��3,4Ϊ>12)ȡ�������һ��,��20160930
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

//��װ�������ֶ�
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

//��������Ĵ�����ó�����
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

//�����ַ�������ó����ڴ�
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

//�ж��Ƿ�Ϊ�Ϸ��������ַ���
//�ǣ������ַ���
//�񣺷���''
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

//'������ֵ����ת�������������ַ���(YYYY-MM-DD)
//'������6λ,8λ,4λ
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
        	dd = "01"  ;  //'δȷ������ʱ��01����
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
        	dd = "01" ;  // 'δȷ������ʱ��01����
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



//��Ӫ��ҵ
Ext.ux.VendorComboBox=Ext.extend(Ext.form.ComboBox,{
	fieldLabel : $g('��Ӫ��ҵ'),
	anchor : '90%',
	valueField : 'RowId',
	displayField : 'Description',
	emptyText : $g('��Ӫ��ҵ...'),
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
			this.store.removeAll();    //load֮ǰremoveԭ��¼���������׳���
			this.store.setBaseParam("filter",filter);
			this.store.load({params:{start:0,limit:20}});
		});
		Ext.ux.VendorComboBox.superclass.initComponent.call(this);
	}
});

	 

//�б�
Ext.ux.ZBComboBox=Ext.extend(Ext.form.ComboBox,{
	fieldLabel : $g('�Ƿ��б�'),
	anchor : '90%',
	valueField : 'rowid',
	displayField : 'desc',
	emptyText : $g('�Ƿ��б�...'),
	selectOnFocus : true,
	mode: 'local',
	forceSelection : true,
	initComponent:function(){
		
		this.store=new Ext.data.SimpleStore({
		fields: ['desc', 'rowid'],
		data : [[$g('ȫ��'),'1'],[$g('�б�'),'2'],[$g('���б�'),'3']]
		});
		Ext.ux.ZBComboBox.superclass.initComponent.call(this);
	}
});



//���ң�װ������ҩ������
Ext.ux.DispLocComboBox=Ext.extend(Ext.form.ComboBox,{
	fieldLabel : $g('ҩ������'),
	anchor : '90%',
	valueField : 'RowId',
	displayField : 'Description',
	//allowBlank : true,
	//triggerAction : 'query',
	//===================
	forceSelection : true,// ֵΪtrueʱ���޶�ѡ�е�ֵΪ�б��е�ֵ��ֵΪfalse�������û��������ı����õ��ֶΣ�Ĭ��Ϊ false����
	//====================
	emptyText : $g('����...'),
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
		//ָ��store
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
		//�����¼�����������¼�������װ��store
		this.on('beforequery',function(e){
			this.store.removeAll();    //load֮ǰremoveԭ��¼���������׳���
			var filter=this.getRawValue();
			this.store.setBaseParam("locDesc",filter);
			this.store.load({params:{start:0,limit:20}});
		});
		

		Ext.ux.DispLocComboBox.superclass.initComponent.call(this);
	}
});

//���ң�װ������ִ�п���
Ext.ux.ExeLocComboBox=Ext.extend(Ext.form.ComboBox,{
	fieldLabel : $g('ִ�п���'),
	anchor : '90%',
	valueField : 'RowId',
	displayField : 'Description',
	//allowBlank : true,
	//triggerAction : 'query',
	//===================
	forceSelection : true,// ֵΪtrueʱ���޶�ѡ�е�ֵΪ�б��е�ֵ��ֵΪfalse�������û��������ı����õ��ֶΣ�Ĭ��Ϊ false����
	//====================
	emptyText : $g('����...'),
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
		//ָ��store
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
		//�����¼�����������¼�������װ��store
		this.on('beforequery',function(e){
			this.store.removeAll();    //load֮ǰremoveԭ��¼���������׳���
			var filter=this.getRawValue();
			this.store.setBaseParam("locDesc",filter);
			this.store.load({params:{start:0,limit:20}});
		});
		

		Ext.ux.ExeLocComboBox.superclass.initComponent.call(this);
	}
});
//����
Ext.ux.LocWardComboBox=Ext.extend(Ext.form.ComboBox,{
	fieldLabel : $g('����'),
	anchor : '90%',
	valueField : 'RowId',
	displayField : 'Description',
	emptyText : $g('����...'),
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
			this.store.removeAll();    //load֮ǰremoveԭ��¼���������׳���
			this.store.setBaseParam("filter",filter);
			this.store.load({params:{start:0,limit:20}});
		});
		Ext.ux.LocWardComboBox.superclass.initComponent.call(this);
	 }
	});
	
 //��ҩ���
 Ext.ux.DispTypeComboBox=Ext.extend(Ext.form.ComboBox,{
	fieldLabel : $g('��ҩ���'),
	anchor : '90%',
	valueField : 'Type',
	displayField : 'Description',
	emptyText : $g('����...'),
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
			this.store.removeAll();    //load֮ǰremoveԭ��¼���������׳���
			this.store.setBaseParam("filter",filter);
			this.store.load({params:{start:0,limit:20}});
		});
		Ext.ux.DispTypeComboBox.superclass.initComponent.call(this);
	}

});	
//��ȡҽ������
Ext.ux.DoctorDsComboBox=Ext.extend(Ext.form.ComboBox,{
	fieldLabel : $g('ҽ��'),
	anchor : '90%',
	valueField : 'RowId',
	displayField : 'Description',
	emptyText : $g('ҽ��...'),
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
			this.store.removeAll();    //load֮ǰremoveԭ��¼���������׳���
			this.store.setBaseParam("filter",filter);
			this.store.load({params:{start:0,limit:20}});
		});
		Ext.ux.DoctorDsComboBox.superclass.initComponent.call(this);
	 }
	});
/** 
 * ���½ǵ����Ѵ���
 * @author warnx.javaeye.com
 * @params conf �ο�Ext.Window
 *         conf�����autoHide������, Ĭ��3���Զ�����, �����Զ����ص�ʱ��(��λ:��), ����Ҫ�Զ�����ʱ����Ϊfalse
 * @ע: ʹ�ö�����window������(manager:new Ext.WindowGroup()), �ﵽ������ʾ����ǰ��Ч��
 */

Ext.ux.WarnsWindow = Ext.extend(Ext.Window,
    {
        width: 220,
        height: 165,
        layout: 'fit',
        modal: false,
        plain: false,
        shadow: false,
        //ȥ����Ӱ
        draggable: true,
        //Ĭ�ϲ�����ק
        resizable: false,
        closable: true,
        closeAction: 'hide',
        autoScroll: true,
        autoDestroy: true,
        //Ĭ�Ϲر�Ϊ����
        autoHide: 3,
        count:1,//������ʾ���ǵڼ���warnwindow
        //n����Զ����أ�Ϊfalseʱ,���Զ�����
        manager: new Ext.WindowGroup({
        	zseed:99999
        	}),
        //����window��������
        constructor: function(conf)
        {
            Ext.ux.WarnsWindow.superclass.constructor.call(this, conf);
            this.initPosition(true);
        },
        initEvents: function()
        {
           Ext.ux.WarnsWindow.superclass.initEvents.call(this);
            //�Զ�����
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

            Ext.EventManager.onWindowResize(this.initPosition, this); //window��С�ı�ʱ��������������
            Ext.EventManager.on(window, 'scroll', this.initPosition, this); //window�ƶ�������ʱ��������������
        },
        //����: flag - trueʱǿ�Ƹ���λ��
        initPosition: function(flag)
        {
            if (true !== flag && this.hidden)
            { //���ɼ�ʱ������������
                return false;
            }
            var doc = document,
            bd = (doc.body || doc.documentElement);
            //extȡ���ӷ�Χ���(�����淽��ȡ��ֵ��ͬ), ���Ϲ�������
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

            self.initPosition(true); //��ʼ������
            self.el.slideIn('b',
            {
	            duration: 1,
                callback: function()
                {
                    //��ʾ��ɺ�,�ֶ�����show�¼�,����hidden��������false,���򽫲��ܴ���hide�¼�
                    self.fireEvent('show', self);
                    self.hidden = false;
                }
            });
            return false; //��ִ��Ĭ�ϵ�show
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
                    //��������ִ�����ʱ,�ֶ�����hide�¼�,����hidden��������true
                    self.fireEvent('hide', self);
                    self.hidden = true;
                }
            });
            return false; //��ִ��Ĭ�ϵ�hide
        }
    });
/**
 * NumberField�ؼ���չ,����С��λ��(decimalPrecision)
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

//ҽԺ��װ������Ȩ��ҽԺ
Ext.ux.HospComboBox=Ext.extend(Ext.form.ComboBox,{
	fieldLabel : $g('ҽԺ'),
	anchor : '90%',
	valueField : 'RowId',
	displayField : 'Description',
	//===================
	forceSelection : true,// ֵΪtrueʱ���޶�ѡ�е�ֵΪ�б��е�ֵ��ֵΪfalse�������û��������ı����õ��ֶΣ�Ĭ��Ϊ false����
	//====================
	emptyText : $g('ҽԺ...'),
	selectOnFocus : false,
	minChars : 3,
	pageSize : 20,
	width : 300,
	listWidth : 300,
	typeAhead:false,
	valueNotFoundText : '',
	defaultHosp:null,  //�������ԣ�Ĭ�Ͽ���,"",������Ĭ�Ͽ���;{RowId:ctloc_rowid,Description:ctloc_desc}����Ĭ�Ͽ���Ϊָ��ֵ�����Ĭ�Ͽ���Ϊ��½���ң��������ø�����
	tablename:null,
	dataid:null,
	params:null,
	stores:[], //ѡ��ҽԺʱ,��Ҫ����ҽԺ���¼������ݵ�store
	grids:[], //ѡ��ҽԺʱ,��Ҫ������ݵ�grid
	selHandler:null, //ѡ���¼�
	editable:false,   //�Ƿ�����༭
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
		
		//ָ��store
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
		//�����¼�����������¼�������װ��store
		this.on('beforequery',function(e){
			this.store.removeAll();    //load֮ǰremoveԭ��¼���������׳���
			var filter=this.getRawValue();
			//this.store.setBaseParam("FilterDesc",filter);   ����ģ������ 2020-03-20 yangsj
			this.store.setBaseParam("tablename",this.tablename);
			this.store.setBaseParam("dataid",this.dataid);
			for(param in this.params){
				var value=Ext.getCmp(this.params[param]).getValue();
				this.store.setBaseParam(param,value);
			}
			this.store.load({params:{start:0,limit:20}});
		});
		
		//����Ĭ��ֵ
		var defaultData=this.defaultLoc;
		
		if(this.defaultLoc==null){
			// ���õ�ǰ��¼����ΪĬ��ֵ
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
		//ѡ���¼�
		this.on(
			'select',function(combo,record,index){
			 	if(HospId!=this.value){
				 	HospId=this.value; //��ֵ��ȫ�ֱ��������桢ɾ���ȳ���ʹ��;
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
				//Ϊ��ʱ��Ĭ�ϳ���һ��ѡ���ҽԺ
				if(this.value==""){
					this.setValue(HospId); 
				}
			}
		);
		Ext.ux.HospComboBox.superclass.initComponent.call(this);
	}
});
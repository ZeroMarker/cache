

Ext.ns("Ext.ux.renderer","Ext.ux.grid");

Ext.ux.grid.ComboColumn  = Ext.extend(Ext.grid.Column, {
    
    valueField: undefined,
	displayTextField: undefined,
	displayTextFieldEx: undefined,
	gridId:undefined,

    constructor: function(cfg){
   
        Ext.ux.grid.ComboColumn.superclass.constructor.call(this, cfg);

		this.renderer =Ext.ux.renderer.ComboBoxRenderer(this.editor,this.valueField,this.displayTextField,this.displayTextFieldEx);
    }
});

Ext.grid.Column.types['combocolumn'] = Ext.ux.grid.ComboColumn;

/*
 2012-09-06,zhangdongmei,��Ⱦgrid��combox,��������Ⱦʱ��������û�����ݵ����
 combo��������
 valuefield:record�ж�Ӧ���������rowid�ֶ���,
 displaytext:record�ж�Ӧ���������displayText�ֶ���,
 displaytext2:record�ж�Ӧ���������displayText�ֶ���(����displayText����record�������ֶ���ɵ����),
 */
Ext.ux.renderer.ComboBoxRenderer = function(combo,valuefield,displaytext,displaytext2){
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
        //alert(find);
        return find ? find.get(combo.displayField) : combo.valueNotFoundText;
    }
}



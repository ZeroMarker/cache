

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
 2012-09-06,zhangdongmei,渲染grid中combox,适用于渲染时下拉框中没有数据的情况
 combo：下拉框
 valuefield:record中对应的下拉框的rowid字段名,
 displaytext:record中对应的下拉框的displayText字段名,
 displaytext2:record中对应的下拉框的displayText字段名(用于displayText是由record中两个字段组成的情况),
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



Ext.form.TextField.prototype.size = 20; 

Ext.form.TextField.prototype.initValue = function() {   
    if (this.value !== undefined) {   
        this.setValue(this.value);   
    } else if (this.el.dom.value.length > 0) {   

        this.setValue(this.el.dom.value);   
      
    }   
    this.el.dom.size = this.size;   
    if (!isNaN(this.maxLength) && (this.maxLength * 1) > 0  
            && (this.maxLength != Number.MAX_VALUE)) {   
        //Ext.Msg.show({title:'提示',msg:this.maxLengthText+'!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
        
         this.el.dom.maxLength = this.maxLength * 1; 
         this.el.dom.maxLengthText = this.maxLengthText;  
    }   
};  
//    [\u4e00-\u9fa5_a-zA-Z0-9_]{4,10}
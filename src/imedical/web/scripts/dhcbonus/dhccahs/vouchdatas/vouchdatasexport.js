
        Ext.namespace("Herp"); //�Զ���һ�������ռ�

    //���췽��
        Herp.Excel = function(_cfg){
            Ext.apply(this,_cfg);
        };

    //��ʵ������
        Ext.apply(Herp.Excel.prototype, {
            download:function(){
	           var arg=arguments;
	           var url=this.url;
	           if (url==null)
	            {
		        Ext.Msg.show({title:'����',msg:'urlδ֪!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		        return;   
	            }
	           var servlet='/dhccanow/exportexcel';
	           var fileName=this.fileName;
	            if (fileName==null)
	            {
		        Ext.Msg.show({title:'����',msg:'δ���õ����ļ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		        return;   
	            }
	           var sql=replace(arg,this.sql);
	            if (sql==null)
	            {
		        Ext.Msg.show({title:'����',msg:'��ѯ���δ֪!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		        return;   
	            }
	           //��װurl
	           var urlStr=url+servlet+"?sql="+sql+"&fileName="+fileName
	           window.open (urlStr,'newwindow','height=100,width=400,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no') 
	            }
        });
    
function replace(arg,sql)
{  if(sql)
     {
       for(var i=0;i<arg.length;i++)
        {
	      var sql=sql.replace(/\?/,arg[i]);
        }	
	return sql;
     }
     return null;
	}

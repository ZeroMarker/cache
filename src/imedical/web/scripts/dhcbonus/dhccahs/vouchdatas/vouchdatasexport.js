
        Ext.namespace("Herp"); //自定义一个命名空间

    //构造方法
        Herp.Excel = function(_cfg){
            Ext.apply(this,_cfg);
        };

    //类实例方法
        Ext.apply(Herp.Excel.prototype, {
            download:function(){
	           var arg=arguments;
	           var url=this.url;
	           if (url==null)
	            {
		        Ext.Msg.show({title:'错误',msg:'url未知!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		        return;   
	            }
	           var servlet='/dhccanow/exportexcel';
	           var fileName=this.fileName;
	            if (fileName==null)
	            {
		        Ext.Msg.show({title:'错误',msg:'未配置导出文件名!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		        return;   
	            }
	           var sql=replace(arg,this.sql);
	            if (sql==null)
	            {
		        Ext.Msg.show({title:'错误',msg:'查询语句未知!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		        return;   
	            }
	           //组装url
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

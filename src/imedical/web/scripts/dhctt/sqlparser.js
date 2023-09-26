/**
*@author: wanghc
*@date:   2013/4/28
*parse select-sql --->{Object}
*/
/**
*类型
*/
var Types   = {
  UNKNOWN     : 0,              /* 未知的 */
  KEYWORD     : 1,              /* 关键字 */ 
  COLUMN      : 2,              /* 列名 */
  TABLE       : 3,              /* 表名 */
  SCHEMA      : 4,              /* 模式 */
  REF         : 5,              /* 指向 */
  COMMENT     : 99             /*    注  释 */
};
var DEFAULTSCHEMA = "SQLUser";
(function () {
    var root = this;
    var SqlParser = {version:'0.1'};
    var IS_SELECTRGE = /^SELECT\s+.*/gi;
    var SELECTREG = /^SELECT\s+(\w)*\s+()/;
    SqlParser.Keywords = ["and","as","asc","distince","select","select * from ","from","insert","insert into","where","order by","desc","delete from","update"];    
	/**
     * 拿到无注释的sql,--为注释
     * @param  {String} statement Sql语句
     * @return {String}           无注释sql
     */
    SqlParser.getSQLStatement = function(statement){
        var tmp="",tmpindex=-1,tmparr=[],j=0;
        var queryarr = statement.split("\n");
        for (var i = 0; i<queryarr.length; i++) {
            tmp = queryarr[i];
            tmpindex = tmp.indexOf("--");
            if(-1 == tmpindex){
                tmparr[j++] = tmp;
            }else{
                tmp = tmp.slice(0,tmpindex);
                if(tmp!=""){
                    tmparr[j++] = tmp;                    
                }
            }
        };
        tmp = tmparr.join(" ");
        tmp = tmp.replace(/(^\s+)|(\s+$)/g,"");
        /*if (DHC && DHC.Ajax) {
            DHC.Ajax.req({
                url: "dhctt.request.csp", 
                data: {SQLStatement:tmp, act:"getSQLStatement"}, 
                type:"POST",         
                async: true,
                dataType: "json",
                success: function handler(obj){                                                 
                    tableSet[obj.schema] = obj.data;            
                }
            })  
        };*/
        //tmp = tmp.toLowerCase();        
        return tmp;    
    };
    SqlParser.parse = function (inquery) {
        var stat = SqlParser.getSQLStatement(inquery);
        if (stat.length<6){
           return {columns:[],tables:[],schemas:[]}; 
        }
        var tmp = stat.slice(0,6).toUpperCase();
        if(tmp=="SELECT"){
            return SqlParser.selectParse(inquery);
        }else if (tmp == "UPDATE"){
            return SqlParser.updateParse(inquery);
        }else if(tmp == "INSERT"){
            return SqlParser.insertParse(inquery);
        }else if(tmp == "DELETE"){
            return SqlParser.deleteParse(inquery);
        }
	};
    SqlParser.selectParse = function(inquery){
        var columns = [],tables = [],schemas = [];      /*select token as a, token1 b, token2 from ...;*/
        var tks = [],tmp='',i=0;
        var afterfrom='',prewhile="",afterwhile="";
        var query = SqlParser.getSQLStatement(inquery);
        var froms = query.split(" from");        
        if (froms.length==1){return {tables:tables,columns:columns,schemas:schemas};}
        if(froms.length==2 && query.indexOf("select ")==-1) {return {tables:tables,columns:columns,schemas:schemas};}
        var prefrom = froms[0].split("select ")[1];
        var cols = prefrom.split(",");       
        for (i = 0; i <= cols.length - 1; i++) {            
            tmp = cols[i].trim();
            columns.push(tmp.split(" ")[0]);
        };
        if (froms.length==1) {return {tables:tables,columns:columns,schemas:schemas};};
        if(froms.length>1){
            afterfrom = froms[1];           
            var whiles = afterfrom.split(" where ");
            prewhile = whiles[0];
            if(whiles.length>1){
                afterwhile = whiles[1];    
            }            
            var tabs = prewhile.split(",");
            tmp='';
            for (i = 0; i <= tabs.length - 1; i++) {
                tmp = tabs[i].trim();
                tmp = tmp.split(" ")[0];
                if(tmp.indexOf(".")>-1){
                    schemas.push(tmp.split(".")[0]);
                    if(tmp.split(".").length>1){
                        tables.push(tmp.split(".")[1]);
                    }
                }else{
                    schemas.push(DEFAULTSCHEMA);
                    tables.push(tmp);
                }
            };
        }       
        tks = {tables:tables,columns:columns,schemas:schemas};
        return tks;
    };
    SqlParser.updateParse = function (inquery) {
        var columns = [],tables = [],schemas = [];      /*update token as a, set token1=1, token2=2 where col1=1 and col2=2*/
        var tks = [],tmp='',i=0;        
        var query = SqlParser.getSQLStatement(inquery);
        var updates = query.split("update ");
        if(updates.length==1) {return {columns:columns,tables:tables,schemas:schemas};}
        var tabs = updates[1].split(" set ")[0];
        tabs = tabs.split(",");
        tmp='';
        for (i = 0; i <= tabs.length - 1; i++) {
            tmp = tabs[i].trim();
            tmp = tmp.split(" ")[0];
            if(tmp.indexOf(".")>-1){
                schemas.push(tmp.split(".")[0]);
                if(tmp.split(".").length>1){
                    tables.push(tmp.split(".")[1]);
                }
            }else{
                schemas.push(DEFAULTSCHEMA);
                tables.push(tmp);
            }
        };
        tks = {columns:columns,tables:tables,schemas:schemas};
        return tks;
    };
    SqlParser.insertParse = function(inquery){
        var columns = [],tables = [],schemas = [];      /*insert into tabelname () valuse()*/
        var tks = [],tmp='',i=0;        
        var query = SqlParser.getSQLStatement(inquery);
        var inserts = query.split("insert into");
        if(inserts.length==1) {return {columns:columns,tables:tables,schemas:schemas};}
        var tabs = inserts[1].split("(")[0];
        tabs = tabs.split(",");
        tmp='';
        for (i = 0; i <= tabs.length - 1; i++) {
            tmp = tabs[i].trim();
            tmp = tmp.split(" ")[0];
            if(tmp.indexOf(".")>-1){
                schemas.push(tmp.split(".")[0]);
                if(tmp.split(".").length>1){
                    tables.push(tmp.split(".")[1]);
                }
            }else{
                schemas.push(DEFAULTSCHEMA);
                tables.push(tmp);
            }
        };
        tks = {columns:columns,tables:tables,schemas:schemas};
        return tks;
    }
    SqlParser.deleteParse = function(inquery){
        var columns = [],tables = [],schemas = [];      /*delete from tabelname where ...*/
        var tks = [],tmp='',i=0;        
        var query = SqlParser.getSQLStatement(inquery);
        var deletes = query.split("delete from");
        if(deletes.length==1) {return {columns:columns,tables:tables,schemas:schemas};}
        var tabs = deletes[1].split("where")[0];
        tabs = tabs.split(",");
        tmp='';
        for (i = 0; i <= tabs.length - 1; i++) {
            tmp = tabs[i].trim();
            tmp = tmp.split(" ")[0];
            if(tmp.indexOf(".")>-1){
                schemas.push(tmp.split(".")[0]);
                if(tmp.split(".").length>1){
                    tables.push(tmp.split(".")[1]);
                }
            }else{
                schemas.push(DEFAULTSCHEMA);
                tables.push(tmp);
            }
        };
        tks = {columns:columns,tables:tables,schemas:schemas};
        return tks;
    }
    /**
     * 在query中获得index处的前方最后一个单词,
     * @param  {String} query 字符串
     * @param  {Number} index 位置
     * @return {String}       单词
     */
    SqlParser.getLastWord = function(query,index){
        var lastwordIndex = SqlParser.getLastWordIndex(query,index)+1;
        var lastString = query.slice(lastwordIndex,index+1)        
        return lastString;
    };
    SqlParser.getLastWordIndex = function(query,index){
        //insert into table(col, col1)--(
        var tmp = query.slice(0,index+1);
        return Math.max(tmp.lastIndexOf(" "),tmp.lastIndexOf("."),tmp.lastIndexOf("("),tmp.lastIndexOf(","),tmp.lastIndexOf("\n"));        
    };
    
    /** 
    * 获得将要输入的类型与pre字符
    * select * from pa {type:Types.TABLE,schema:'SQLUser',table:'',value:'pa'}      ;光标在最后
    *select paadm_d from pa_adm {type:Types.COLUMN,schema:'SQLUser',table:'pa_adm',value:'paadm_d'}    ;光标在d后面
    *select paadm_papmi_dr from pa_adm where paadm_t {type:Types.COLUMN,schema:'SQLUser',table:'pa_adm',value:'paadm_t'}   ;光标在最后
    *--select * from pa_adm where paadm_t 
    *{type:Types.COMMENT,schema:'',table:'',value:'select * from pa_adm where paadm_t'}
    *@param {String} query 查询语句
    *@param {Number} index 光标所在位置
    *@return {Object} tks 
    */
    SqlParser.getInputTypes = function (query,index) {
        var tks = {}, type = Types.UNKNOWN;
        var tmp = '', cur = '', sub = '', nxt = '',tmpindex='',lastString="";
        var indexChar = query.charAt(index);
        lastString = SqlParser.getLastWord(query,index);
        var obj = SqlParser.parse(query);        
        /* 只写了模式名,没有表名时返回 */
        if(obj.tables.length==1 && obj.tables[0]=="") {
            /* 提示表名,关键字 */
            tks = {type: Types.TABLE, schema: obj.schemas[0]||DEFAULTSCHEMA,  table: "", value: "" };            
        }else if(obj.tables.length>=1 && obj.tables[0]!="" && lastString.indexOf("->")==-1){
            if (lastString == obj.tables[obj.tables.length-1] && query.indexOf("where")==-1){
            	/* 提示表名,关键字 */
           	 	tks = {type: Types.TABLE, schema: obj.schemas[0]||DEFAULTSCHEMA,  table: "", value: lastString };            
            }else{
	        	/* 提示表名,列名,关键字 */
            	tks = {type:Types.COLUMN,schema:obj.schemas[0],table:obj.tables[0], value:lastString};
            }
        }else if(obj.tables.length>=1 && obj.tables[0]!="" && lastString.indexOf("->")>-1){
            /* 提示指向表的列名 */
            tks = {type:Types.REF, schema:obj.schemas[0], table:obj.tables[0], value:lastString};
        }else{
            tks = {type:Types.KEYWORD, schema:"",table:"",value:lastString};
        }
        return tks;

    };
    /*兼容node.js*/
    if (typeof exports !== 'undefined') {
        if (typeof module !== 'undefined' && module.exports) {
            exports = module.exports = SqlParser;
        }
        exports = SqlParser;
    } 
    /*兼容amd*/
    else if (typeof define === 'function' && define.amd) {
        // Register as a named module with AMD.
        define('underscore', function () {
            return SqlParser;
        });
    }else {
        root['SqlParser'] = SqlParser;
    }
}).call(this);

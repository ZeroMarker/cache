var a=[{company:'herp',name:'xiaoming',age:'23',like:'red'},{company:'herp',name:'xiaoming',age:'33',like:'blue'},{company:'herp',name:'liumei',age:'23',like:'red'},{company:'herp',name:'liumei',age:'33',like:'blue'},{company:'herp',name:'liumei',age:'55',like:'grey'}];
//此对象下的方法主要是将后台获得的json串进行横向扩展
//参数：data：获得的后台rows下的数组，changeablecolumn：要横向扩展的字段，uselesscolumn:横向扩展字段下的值
//  一月 二月 三月 changeablecolumn
//	32  54  69  uselesscolumn

var transform = {
  //生成列的固定部分
  createStaticColumn: function (data, changeablecolumn, uselesscolumn) {
    var columns = new Array();
    if (data.length != 0) {
      for (var p in data[0]) {
        if (p != changeablecolumn && p != uselesscolumn) {
          columns.push(p);
        }
      }
    }
    return columns
  },
  //create real column
  //生成完整的列
  createColumn: function (data, changeablecolumn, uselesscolumn) {
    return this.createStaticColumn(data, changeablecolumn, uselesscolumn).concat(this.createChangeableColumn(data, changeablecolumn));
  },
  //create changeable columns depend on data 
  //data 为传入的json数组，ccolumn为变化的字段
  //生成列的动态部分
  createChangeableColumn: function (data, ccolumn) {
    var columns = new Array();
    for (var i = 0; i < data.length; i++) {
      var column = data[i][ccolumn];
      if (!this.iselementinArray(columns, column)) {
        columns.push(column);
      }
    }
    return columns;
  },
  //if element is in array
  //
  iselementinArray: function (array, e) {
    var flag = false;
    for (var p in array) {
      if (e == array[p]) {
        flag = true;
        break;
      }
      //console.log(array[p]);

    }
    return flag;
  },
  //生成完成横向扩展的json串
  createjson: function (data, changeablecolumn, uselesscolumn) {
    var columns = this.createColumn(data, changeablecolumn, uselesscolumn);
    var staticcolumns = this.createStaticColumn(data, changeablecolumn, uselesscolumn);

    var myArray = new Array();
    for (var i = 0; i < data.length; i++) {
      // console.log(myArray);
      //console.log('data[i] '+data[i]+' myArray'+'staticclm'+staticcolumns);

      var index = this.isObjectInArray(data[i], myArray, staticcolumns);

      if (index == - 1) {

        var element = this.setvalue(data[i],{} , staticcolumns, columns, changeablecolumn, uselesscolumn);
        myArray.push(element);

      } 
      else {

        //console.log(myArray[index])
        //myArray[index] = this.setvalue(data[i], myArray[index], staticcolumns,columns, changeablecolumn, uselesscolumn);
        myArray[index] = this.updatevalue(data[i], myArray[index], changeablecolumn, uselesscolumn);

      }

    }
    return myArray;
  },
  setvalue: function (object, element, thestaticcolumns, thefullcolumns, changeablecolumn, uselesscolumn) {
    var element = element || {
    };
    // console.log(element);
    for (var i = 0; i < thefullcolumns.length; i++) {
      var p = thefullcolumns[i];
      // if(thestaticcolumns.indexOf(p)!=-1){
      element[p] = object[p];
      //}
      // else
      if (p == object[changeablecolumn]) {
        element[p] = object[uselesscolumn];
      }
    }
    return element;
  },
  updatevalue: function (object, element, changeablecolumn, uselesscolumn) {
     element[object[changeablecolumn]] = object[uselesscolumn];
    return element;
  },
  isObjectInArray: function (object, data, columns) {
    var flag = - 1;
    for (var i = 0; i < data.length; i++) {
      //console.log(columns);
      if (this.badcompare(object, data[i], columns)) {
        flag = i;
        break;
      }
    }
    return flag;
  },
  badcompare: function (myobject, itsobject, columns) {
    var flag = true;
    for (var i = 0; i < columns.length; i++) {
      if (myobject[columns[i]] != itsobject[columns[i]]) {
        flag = false;
        break;
      }
    }
    return flag;
  }
};


//函数
//var columnnameArray=['aa','bb'];
var gridcolumncreator=function(columnnameArray){//columnnameArray检查点
	//alert(columnnameArray.length);
	var columns=new Array();
	for (var i=0;i<columnnameArray.length;i++){
		var item=
		{
			id       : columnnameArray[i], 
            header   : columnnameArray[i], 
            width    : (columnnameArray[i].length)*14, 
            sortable : true, 
            //renderer : 'usMoney', 
            dataIndex: columnnameArray[i],
            renderer: function(value, metaData, record, rowIndex, colIndex, store) {
                // provide the logic depending on business rules
                // name of your own choosing to manipulate the cell depending upon
                // the data in the underlying Record object.
               // console.log(rowIndex+"-value--"+colIndex)
              //  console.log(value);
            	value=value||"";
            	var thevalue=value.split("||")[1];
            	
                if (value!='') {
                    //metaData.css : String : A CSS class name to add to the TD element of the cell.
                    //metaData.attr : String : An html attribute definition string to apply to
                    //                         the data container element within the table
                    //                         cell (e.g. 'style="color:red;"').
                    //metaData.css = 'name-of-css-class-you-will-define';
                	return '<html><font>'+thevalue+'<font/></html>';
                
                }else if(value==''){
	               // alert(value);
                	return '<html><font style="background:#CCCCCC">未检查<font/></html>';
                	
                }
                return value;
             }
        }
		columns.push(item);
	//	console.log(columns);
	}
	return columns;
};
//将json串转化成array
var jsontoarray=function(jsonArray){
	var myarray=new Array();
	for(var i=0;i<jsonArray.length;i++){
		var element=[];
		for(var p in jsonArray[i]){
			element.push(jsonArray[i][p]);
		}
		myarray.push(element);
		
	}
	return myarray;
	
}
//var columnnameArray=['aa','bb'];
var creatorarryfields=function (columnnameArray){
	var columns=new Array();
	for(var i=0;i<columnnameArray.length;i++){
		columns.push({name:columnnameArray[i]});
		
	}
	columns.push({name:columnnameArray[i]});
	return columns;
}
//调试
//mydata = transform.createjson(a, 'like', 'age');
function ispatientfields(parameter,myfields){
	
	for(var i=0;i<myfields.length;i++){
		if(myfields[i]['name']==parameter){
			return true;
		}
		
	}
	return false;
	}


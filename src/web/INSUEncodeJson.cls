Class web.INSUEncodeJson Extends %RegisteredObject [ ProcedureBlock ]
{

Parameter QUOT = """";

Parameter ROWID = "RowID";

/// 将字符串转化成json格式
/// s str="血尿素氮＞40mg*dl，血肌酐＞1.5mg*dl（非因脱水或阻塞"
/// w ##class(web.INSUEncodeJson).Escape(str)
ClassMethod Escape(str As %String) As %String
{
	s str=$zstrip(str,"*C")
	
	s str=$replace(str,"/","(a#a)")   ;+dongkf 2016 09 06
	s ret=$zconvert(str,"O","JS")
	s ret=$replace(ret,"(a#a)","/")   ;+dongkf 2016 09 06
	i $find(ret,"\'")>0 d
	.s ret=$replace(ret,"\'","'")
	q ret
}

/// 将各种数据编码成json格式
/// Obj为需要编码的
/// s obj=##class(dhcinsuqc.entitys.INSUQCDictionaryCate).%OpenId(1)
/// d ##class(web.INSUEncodeJson).Encode(.obj)
ClassMethod Encode(ByRef Obj As %String) As %String
{
	Try{
		s data=$d(Obj)
		if data=0{
			/// 无效值
			w "null"
		}
		elseif data=1{
			if $isobject(Obj){
				/// 编码对象
				d ..EncodeObj(.Obj)
			}
			else{
				/// 编码基本数据类型
				d ..EncodeBase(.Obj)
			}
		}
		else{
			/// 编码多维数组
			d ..EncodeMulti(.Obj)
		}
		s ret=0
	}
	catch{
		s ret=-1
	}
	q ret
}

/// 下面方法是内部调用方法，不允许外部调用
ClassMethod EncodeObj(ByRef Obj As %String) As %String [ Private ]
{
	s QUOT=..#QUOT
	s ClassName=Obj.%ClassName(1)
	i ClassName="%Library.ListOfDataTypes"{
		w "["
		f i=1:1:Obj.Size{
			i i>1{
				w ","
			}
			s tmpObj=Obj.GetAt(i)
			d ..Encode(.tmpObj)
		}
		w "]"
	}
	elseif ClassName="%Library.ArrayOfDataTypes"{
		s key=""
		s value=""
		s i=0
		w "{"
		f {
			s value=Obj.GetNext(.key)
			quit:key=""
			s i=$i(i)
			i i>1{
				w ","
			}
			w QUOT_..Escape(key)_QUOT_":"
			d ..Encode(.value)
		}
		w "}"
	}
	elseif ClassName="%Library.ResultSet"{
		s key=""
		s value=""
		s i=0
		s ColumnCount=Obj.GetColumnCount()
		f i=1:1:ColumnCount{
			s Columns(i)=Obj.GetColumnName(i)
		}
		s j=0
		w "["
		while Obj.%Next(){
			s j=$i(j)
			if j>1{
				w ","
			}
			w "{"
			f i=1:1:ColumnCount{
				if i>1{
					w ","
				}
				s key=Columns(i)
				s value=Obj.Get(key)
				w QUOT_..Escape(key)_QUOT_":"_QUOT_..Escape(value)_QUOT
			}
			w "}"
		}
		w "]"
	}
	else{
		/// 通用对象处理方法
		s key=""
		s value=""
		w "{"
		w QUOT_..Escape(..#ROWID)_QUOT_":"
		if Obj.%IsA("%Library.Persistent"){
			s value=Obj.%Id()
		}else{
			s value=""
		}
		d ..Encode(.value)
		s key=""
		f {
			s key=$o(^oddCOM(ClassName,"a",key))
			quit:key=""
			i $e(key,1)="%"{
				continue
			}
			s private=$g(^oddDEF(ClassName,"a",key,35))
			if private=1{
				continue
			}
			w ","_QUOT_..Escape(key)_QUOT_":"
			s type=$g(^oddCOM(ClassName,"a",key,5))
			i type="" {
				s tmpClassName=^oddCOM(ClassName,"a",key,2)
				s type=$g(^oddCOM(tmpClassName,"a",key,5))
			}
			s value=$ZOBJPROPERTY(Obj,key)
			s value=..DataToDisplay(value,type)
			d ..Encode(.value)
		}
		w "}"
	}
	q "0"
}

ClassMethod EncodeBase(ByRef Obj As %String) As %String [ Private ]
{
	/// 此方法应该是整个递归的出口，不允许再次调用Encode方法
	s QUOT=..#QUOT
	//i $isvalidnum(Obj){
	//	if $e(Obj)="."
	//	{
	//		s Obj=0_Obj
	//	}
	//	w Obj
	//}
	//else{
		///	其余统一当成字符串处理
		w QUOT_..Escape(Obj)_QUOT
	//}
	q "0"
}

/// 多维数组json编码
ClassMethod EncodeMulti(ByRef Obj As %String) As %String [ Private ]
{
	s QUOT=..#QUOT
	s data=$d(Obj)
	if data=11{
		//尝试获取格式说明
	}
	s model="List"
	//检测后几个key(非数字肯定在数字后面)
	//如果后几个key出现非数字，则按照Object处理，否则按照数组处理
	s num=10
	s key=""
	s i=0
	f {
		s key=$o(Obj(key),-1)
		s i=$i(i)
		quit:((key="")||(i>num))
		if '$isvalidnum(key){
			s model="Object"
		}
	}
	
	s key=""
	s i=0
	i model="Object"{
		w "{"
	}
	else{
		w "["
	}
	f {
		s key=$o(Obj(key))
		quit:key=""
		s i=$i(i)
		i i>1{
			w ","
		}
		i model="Object"{
			w QUOT_..Escape(key)_QUOT_":"
		}
		m value=Obj(key)
		d ..Encode(.value)
	}
	i model="Object"{
		w "}"
	}
	else{
		w "]"
	}
	q "0"
}

ClassMethod StringToDate(StrDate As %String) As %String
{
	s ret=""
	if StrDate?4N2P2P{
		s ret=$zdh(StrDate,3)
	}
	else{
		s ret=StrDate
	}
	q ret
}

ClassMethod DataToDisplay(Data As %String, Type As %String) As %String
{
	s ret=""
	q:Data="" ret
	i Type="%Library.Date"{
		s ret=$zd(Data,3)
	}
	elseif Type="%Library.Time"{
		s ret=$zt(Data,1)
	}
	else{
		s ret=Data
	}
	q ret
}

}

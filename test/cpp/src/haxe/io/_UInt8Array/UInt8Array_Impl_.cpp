// Generated by Haxe 4.2.0-rc.1+d0fd88b9b
#include <hxcpp.h>

#ifndef INCLUDED_haxe_io_ArrayBufferViewImpl
#include <haxe/io/ArrayBufferViewImpl.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_haxe_io__ArrayBufferView_ArrayBufferView_Impl_
#include <haxe/io/_ArrayBufferView/ArrayBufferView_Impl_.h>
#endif
#ifndef INCLUDED_haxe_io__UInt8Array_UInt8Array_Impl_
#include <haxe/io/_UInt8Array/UInt8Array_Impl_.h>
#endif

HX_LOCAL_STACK_FRAME(_hx_pos_8e74ceb5dcba13b5_70_fromData,"haxe.io._UInt8Array.UInt8Array_Impl_","fromData",0x9bed9713,"haxe.io._UInt8Array.UInt8Array_Impl_.fromData","C:\\HaxeToolkit\\haxe\\std/haxe/io/UInt8Array.hx",70,0x7b7c33ea)
HX_LOCAL_STACK_FRAME(_hx_pos_8e74ceb5dcba13b5_85_fromBytes,"haxe.io._UInt8Array.UInt8Array_Impl_","fromBytes",0xbd069362,"haxe.io._UInt8Array.UInt8Array_Impl_.fromBytes","C:\\HaxeToolkit\\haxe\\std/haxe/io/UInt8Array.hx",85,0x7b7c33ea)
namespace haxe{
namespace io{
namespace _UInt8Array{

void UInt8Array_Impl__obj::__construct() { }

Dynamic UInt8Array_Impl__obj::__CreateEmpty() { return new UInt8Array_Impl__obj; }

void *UInt8Array_Impl__obj::_hx_vtable = 0;

Dynamic UInt8Array_Impl__obj::__Create(::hx::DynamicArray inArgs)
{
	::hx::ObjectPtr< UInt8Array_Impl__obj > _hx_result = new UInt8Array_Impl__obj();
	_hx_result->__construct();
	return _hx_result;
}

bool UInt8Array_Impl__obj::_hx_isInstanceOf(int inClassId) {
	return inClassId==(int)0x00000001 || inClassId==(int)0x3bec3945;
}

 ::haxe::io::ArrayBufferViewImpl UInt8Array_Impl__obj::fromData( ::haxe::io::ArrayBufferViewImpl d){
            	HX_STACKFRAME(&_hx_pos_8e74ceb5dcba13b5_70_fromData)
HXDLIN(  70)		return d;
            	}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(UInt8Array_Impl__obj,fromData,return )

 ::haxe::io::ArrayBufferViewImpl UInt8Array_Impl__obj::fromBytes( ::haxe::io::Bytes bytes,::hx::Null< int >  __o_bytePos, ::Dynamic length){
            		int bytePos = __o_bytePos.Default(0);
            	HX_STACKFRAME(&_hx_pos_8e74ceb5dcba13b5_85_fromBytes)
HXDLIN(  85)		return ::haxe::io::_UInt8Array::UInt8Array_Impl__obj::fromData(::haxe::io::_ArrayBufferView::ArrayBufferView_Impl__obj::fromBytes(bytes,bytePos,length));
            	}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(UInt8Array_Impl__obj,fromBytes,return )


UInt8Array_Impl__obj::UInt8Array_Impl__obj()
{
}

bool UInt8Array_Impl__obj::__GetStatic(const ::String &inName, Dynamic &outValue, ::hx::PropertyAccess inCallProp)
{
	switch(inName.length) {
	case 8:
		if (HX_FIELD_EQ(inName,"fromData") ) { outValue = fromData_dyn(); return true; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"fromBytes") ) { outValue = fromBytes_dyn(); return true; }
	}
	return false;
}

#ifdef HXCPP_SCRIPTABLE
static ::hx::StorageInfo *UInt8Array_Impl__obj_sMemberStorageInfo = 0;
static ::hx::StaticInfo *UInt8Array_Impl__obj_sStaticStorageInfo = 0;
#endif

::hx::Class UInt8Array_Impl__obj::__mClass;

static ::String UInt8Array_Impl__obj_sStaticFields[] = {
	HX_("fromData",b4,24,2f,a0),
	HX_("fromBytes",a1,f2,20,72),
	::String(null())
};

void UInt8Array_Impl__obj::__register()
{
	UInt8Array_Impl__obj _hx_dummy;
	UInt8Array_Impl__obj::_hx_vtable = *(void **)&_hx_dummy;
	::hx::Static(__mClass) = new ::hx::Class_obj();
	__mClass->mName = HX_("haxe.io._UInt8Array.UInt8Array_Impl_",ef,b5,c9,76);
	__mClass->mSuper = &super::__SGetClass();
	__mClass->mConstructEmpty = &__CreateEmpty;
	__mClass->mConstructArgs = &__Create;
	__mClass->mGetStaticField = &UInt8Array_Impl__obj::__GetStatic;
	__mClass->mSetStaticField = &::hx::Class_obj::SetNoStaticField;
	__mClass->mStatics = ::hx::Class_obj::dupFunctions(UInt8Array_Impl__obj_sStaticFields);
	__mClass->mMembers = ::hx::Class_obj::dupFunctions(0 /* sMemberFields */);
	__mClass->mCanCast = ::hx::TCanCast< UInt8Array_Impl__obj >;
#ifdef HXCPP_SCRIPTABLE
	__mClass->mMemberStorageInfo = UInt8Array_Impl__obj_sMemberStorageInfo;
#endif
#ifdef HXCPP_SCRIPTABLE
	__mClass->mStaticStorageInfo = UInt8Array_Impl__obj_sStaticStorageInfo;
#endif
	::hx::_hx_RegisterClass(__mClass->mName, __mClass);
}

} // end namespace haxe
} // end namespace io
} // end namespace _UInt8Array

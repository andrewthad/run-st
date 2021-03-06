{-# language BangPatterns #-}
{-# language MagicHash #-}
{-# language RankNTypes #-}
{-# language UnboxedTuples #-}

module Control.Monad.ST.Run
  ( -- * Arrays
    runArrayST
  , runSmallArrayST
  , runByteArrayST
  , runPrimArrayST
  , runUnliftedArrayST
    -- * Integral Types
  , runIntST
  , runInt8ST
  , runInt16ST
  , runInt32ST
  , runWordST
  , runWord8ST
  , runWord16ST
  , runWord32ST
    -- * Char
  , runCharST
    -- * Floating Point Types
  , runFloatST
  , runDoubleST
    -- * Tuples
  , runIntArrayST
  , runIntByteArrayST
  , runIntIntByteArrayST
  , runWordArrayST
  , runWordByteArrayST
    -- * Maybes
  , runMaybeByteArrayST
  ) where

import GHC.Word (Word8(W8#),Word16(W16#),Word32(W32#))
import GHC.Int (Int8(I8#),Int16(I16#),Int32(I32#))
import GHC.Exts (Char(C#),Int(I#),Word(W#),runRW#)
import GHC.Exts (Double(D#),Float(F#))
import Data.Primitive.Array (Array(Array))
import Data.Primitive.SmallArray (SmallArray(SmallArray))
import Data.Primitive.ByteArray (ByteArray(ByteArray))
import Data.Primitive.PrimArray (PrimArray(PrimArray))
import Data.Primitive.Unlifted.Array (UnliftedArray(UnliftedArray))
import GHC.ST (ST(ST))

runArrayST :: (forall s. ST s (Array a)) -> Array a
{-# inline runArrayST #-}
runArrayST f = Array (runRW# (\s0 -> case f of { ST g -> case g s0 of { (# _, Array r #) -> r }}))

runSmallArrayST :: (forall s. ST s (SmallArray a)) -> SmallArray a
{-# inline runSmallArrayST #-}
runSmallArrayST f = SmallArray (runRW# (\s0 -> case f of { ST g -> case g s0 of { (# _, SmallArray r #) -> r }}))

runByteArrayST :: (forall s. ST s ByteArray) -> ByteArray
{-# inline runByteArrayST #-}
runByteArrayST f = ByteArray (runRW# (\s0 -> case f of { ST g -> case g s0 of { (# _, ByteArray r #) -> r }}))

runPrimArrayST :: (forall s. ST s (PrimArray a)) -> PrimArray a
{-# inline runPrimArrayST #-}
runPrimArrayST f = PrimArray (runRW# (\s0 -> case f of { ST g -> case g s0 of { (# _, PrimArray r #) -> r }}))

runUnliftedArrayST :: (forall s. ST s (UnliftedArray a)) -> UnliftedArray a
{-# inline runUnliftedArrayST #-}
runUnliftedArrayST f = UnliftedArray (runRW# (\s0 -> case f of { ST g -> case g s0 of { (# _, UnliftedArray r #) -> r }}))

runCharST :: (forall s. ST s Char) -> Char
{-# inline runCharST #-}
runCharST f = C# (runRW# (\s0 -> case f of { ST g -> case g s0 of { (# _, C# r #) -> r }}))

runFloatST :: (forall s. ST s Float) -> Float
{-# inline runFloatST #-}
runFloatST f = F# (runRW# (\s0 -> case f of { ST g -> case g s0 of { (# _, F# r #) -> r }}))

runDoubleST :: (forall s. ST s Double) -> Double
{-# inline runDoubleST #-}
runDoubleST f = D# (runRW# (\s0 -> case f of { ST g -> case g s0 of { (# _, D# r #) -> r }}))

runIntST :: (forall s. ST s Int) -> Int
{-# inline runIntST #-}
runIntST f = I# (runRW# (\s0 -> case f of { ST g -> case g s0 of { (# _, I# r #) -> r }}))

runWordST :: (forall s. ST s Word) -> Word
{-# inline runWordST #-}
runWordST f = W# (runRW# (\s0 -> case f of { ST g -> case g s0 of { (# _, W# r #) -> r }}))

runWord8ST :: (forall s. ST s Word8) -> Word8
{-# inline runWord8ST #-}
runWord8ST f = W8# (runRW# (\s0 -> case f of { ST g -> case g s0 of { (# _, W8# r #) -> r }}))

runWord16ST :: (forall s. ST s Word16) -> Word16
{-# inline runWord16ST #-}
runWord16ST f = W16# (runRW# (\s0 -> case f of { ST g -> case g s0 of { (# _, W16# r #) -> r }}))

runWord32ST :: (forall s. ST s Word32) -> Word32
{-# inline runWord32ST #-}
runWord32ST f = W32# (runRW# (\s0 -> case f of { ST g -> case g s0 of { (# _, W32# r #) -> r }}))

runInt8ST :: (forall s. ST s Int8) -> Int8
{-# inline runInt8ST #-}
runInt8ST f = I8# (runRW# (\s0 -> case f of { ST g -> case g s0 of { (# _, I8# r #) -> r }}))

runInt16ST :: (forall s. ST s Int16) -> Int16
{-# inline runInt16ST #-}
runInt16ST f = I16# (runRW# (\s0 -> case f of { ST g -> case g s0 of { (# _, I16# r #) -> r }}))

runInt32ST :: (forall s. ST s Int32) -> Int32
{-# inline runInt32ST #-}
runInt32ST f = I32# (runRW# (\s0 -> case f of { ST g -> case g s0 of { (# _, I32# r #) -> r }}))

runIntArrayST :: (forall s. ST s (Int, Array a)) -> (Int, Array a)
{-# inline runIntArrayST #-}
runIntArrayST f =
  let !(# t0, t1 #) = runRW# (\s0 -> case f of { ST g -> case g s0 of { (# _, ( I# r0, Array r1 ) #) -> (# r0, r1 #) }})
   in (I# t0, Array t1)

runWordArrayST :: (forall s. ST s (Word, Array a)) -> (Word, Array a)
{-# inline runWordArrayST #-}
runWordArrayST f =
  let !(# t0, t1 #) = runRW# (\s0 -> case f of { ST g -> case g s0 of { (# _, ( W# r0, Array r1 ) #) -> (# r0, r1 #) }})
   in (W# t0, Array t1)

runIntByteArrayST :: (forall s. ST s (Int, ByteArray)) -> (Int, ByteArray)
{-# inline runIntByteArrayST #-}
runIntByteArrayST f =
  let !(# t0, t1 #) = runRW# (\s0 -> case f of { ST g -> case g s0 of { (# _, ( I# r0, ByteArray r1 ) #) -> (# r0, r1 #) }})
   in (I# t0, ByteArray t1)

runIntIntByteArrayST :: (forall s. ST s (Int, Int, ByteArray)) -> (Int, Int, ByteArray)
{-# inline runIntIntByteArrayST #-}
runIntIntByteArrayST f =
  let !(# t0, t1, t2 #) = runRW# (\s0 -> case f of { ST g -> case g s0 of { (# _, ( I# r0, I# r1, ByteArray r2 ) #) -> (# r0, r1, r2 #) }})
   in (I# t0, I# t1, ByteArray t2)

runWordByteArrayST :: (forall s. ST s (Word, ByteArray)) -> (Word, ByteArray)
{-# inline runWordByteArrayST #-}
runWordByteArrayST f =
  let !(# t0, t1 #) = runRW# (\s0 -> case f of { ST g -> case g s0 of { (# _, ( W# r0, ByteArray r1 ) #) -> (# r0, r1 #) }})
   in (W# t0, ByteArray t1)

runMaybeByteArrayST :: (forall s. ST s (Maybe ByteArray)) -> Maybe ByteArray
{-# inline runMaybeByteArrayST #-}
runMaybeByteArrayST f =
  let !x = runRW#
        (\s0 -> case f of { ST g -> case g s0 of
          { (# _, Just (ByteArray r2 ) #) -> (# | r2 #)
          ; (# _, Nothing #) -> (# (# #) | #)
          }})
   in case x of
        (# (# #) | #) -> Nothing
        (# | y #) -> Just (ByteArray y)

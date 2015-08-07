-- GSoC 2015 - Haskell bindings for OpenCog.
{-# LANGUAGE GADTs                 #-}
{-# LANGUAGE DataKinds             #-}
{-# LANGUAGE Rank2Types            #-}
{-# LANGUAGE ScopedTypeVariables   #-}
{-# LANGUAGE TypeOperators         #-}
{-# LANGUAGE ConstraintKinds       #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE KindSignatures        #-}
{-# LANGUAGE UndecidableInstances  #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE TemplateHaskell       #-}

-- | This Module defines atom filters based on their hierarchy.
module OpenCog.AtomSpace.Filter (
    Gen(..)
  , appGen
  , FilterIsChild(..)
  ) where

import OpenCog.AtomSpace.Template       (atomHierarchyFile,declareAtomFilters)
import OpenCog.AtomSpace.Inheritance    (type (<~),Children)
import OpenCog.AtomSpace.AtomType       (AtomType(..))
import OpenCog.AtomSpace.Types          (Atom(..),Gen(..),appGen)
import Data.Proxy                       (Proxy(..))
import Data.Typeable                    (cast,Typeable)

-- | 'Filter' class defines a filter on the list 'b' of atom types.
class Filter a (b::[AtomType]) where
    filtChild :: Typeable c => Proxy b -> Atom c -> Maybe (Gen a)

instance Filter e '[] where
    filtChild _ _ = Nothing

instance (Typeable e,x <~ e,Filter e xs) => Filter e (x ': xs) where
    filtChild _ a = case cast a :: Maybe (Atom x) of
        Just res -> return $ Gen res
        Nothing  -> filtChild (Proxy :: Proxy xs) a

-- | 'FilterIsChild' class defines a filter on the descendants of atom type 'a'.
class FilterIsChild a where
    filtIsChild :: (b <~ AtomT) => Atom b -> Maybe (Gen a)

-- Usage of Template Haskell to generate instances of FilterIsChild for each
-- Atom Type.
declareAtomFilters [atomHierarchyFile|../atomspace/atom_types.script|]

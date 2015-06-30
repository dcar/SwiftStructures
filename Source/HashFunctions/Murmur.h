//
//  Mummur.h
//  SwiftStructures
//
//  Created by Dominick Carro on 6/28/15.
//  Copyright (c) 2015 Arbutus Software Inc. All rights reserved.
//

#ifndef SwiftStructures_Mummur_h
#define SwiftStructures_Mummur_h
#define MIX(h,k,m) { k *= m; k ^= k >> r; k *= m; h *= m; h ^= k; }

unsigned int MurmurHashAligned2 ( const void * key, int len, unsigned int seed );
#endif

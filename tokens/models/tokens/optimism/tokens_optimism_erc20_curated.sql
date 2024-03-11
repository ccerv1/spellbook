{{ config( alias = 'erc20_curated', tags=['static'],
    post_hook='{{ expose_spells(\'["optimism"]\',
                                    "sector",
                                    "tokens",
                                    \'["msilb7"]\') }}')}}

-- token_type: What best describes this token? Is it a vault or LP token, or a lowest-level underlying token?
  -- underlying: This is the rawest form of the token (i.e. USDC, DAI, WETH, OP, UNI, GTC) - Counted in On-Chain Value
  -- receipt: This is a vault/LP receipt token (i.e. HOP-LP-USDC, aUSDC, LP Tokens) - NOT Counted in On-Chain Value (double count)
  -- na: This is a placeholder token that does not have a price

WITH raw_token_list AS (
 SELECT 
        contract_address
      , symbol
      , decimals
      , token_type
    FROM (VALUES 
     (0x4200000000000000000000000000000000000006, 'WETH', 18, 'underlying')
    ,(0xda10009cbd5d07dd0cecc66161fc93d7c9000da1, 'DAI', 18, 'underlying')
    ,(0x68f180fcce6836688e9084f035309e29bf0a2095, 'WBTC', 8, 'underlying')
    ,(0x94b008aa00579c1307b0ef2c499ad98a8ce58e58, 'USDT', 6, 'underlying')
    ,(0x8700daec35af8ff88c16bdf0418774cb3d7599b4, 'SNX', 18, 'underlying')
    ,(0x350a791bfc2c21f9ed5d10980dad2e2638ffa7f6, 'LINK', 18, 'underlying')
    ,(0xb548f63d4405466b36c0c0ac3318a22fdcec711a, 'RGT', 18, 'underlying')
    ,(0xab7badef82e9fe11f6f33f87bc9bc2aa27f2fcb5, 'MKR', 18, 'underlying')
    ,(0x6fd9d7ad17242c41f7131d257212c54a0e816691, 'UNI', 18, 'underlying')
    ,(0x7fb688ccf682d58f86d7e38e03f9d22e7705448b, 'RAI', 18, 'underlying')
    ,(0x7f5c764cbc14f9669b88837ca1490cca17c31607, 'USDC.e', 6, 'underlying')
    ,(0x8c6f28f2f1a3c87f0f938b96d27520d9751ec8d9, 'sUSD', 18, 'underlying')
    ,(0xe405de8f52ba7559f9df3c368500b6e6ae6cee49, 'sETH', 18, 'underlying')
    ,(0xc5db22719a06418028a40a9b5e9a7c02959d0d08, 'sLINK', 18, 'underlying')
    ,(0x298b9b95708152ff6968aafd889c6586e9169f1d, 'sBTC', 18, 'underlying')
    ,(0x25d8039bb044dc227f741a9e381ca4ceae2e6ae8, 'hUSDC', 6, 'underlying') --hop transfer token
    ,(0x2057c8ecb70afd7bee667d76b4cd373a325b1a20, 'hUSDT', 6, 'underlying')
    ,(0x56900d66d74cb14e3c86895789901c9135c95b16, 'hDAI', 18, 'underlying')
    ,(0xe38faf9040c7f09958c638bbdb977083722c5156, 'hETH', 18, 'underlying')
    ,(0x3666f603cc164936c1b87e207f36beba4ac5f18a, 'hUSDC', 6, 'underlying')
    ,(0xa492d3596e8391e376d4f5a5cba5c077b890b094, 'hWBTC', 8, 'underlying')
    ,(0x5da345c942cf804b306d552d343f92b69160b5df, 'HOP-LP-USDC', 18, 'receipt') --hop lp token
    ,(0x2e17b8193566345a2dd467183526dedc42d2d5a8, 'HOP-LP-USDC', 18, 'receipt')
    ,(0xf753a50fc755c6622bbcaa0f59f0522f264f006e, 'HOP-LP-USDT', 18, 'receipt')
    ,(0x22d63a26c730d49e5eab461e4f5de1d8bdf89c92, 'HOP-LP-DAI', 18, 'receipt')
    ,(0x5c2048094baade483d0b1da85c3da6200a88a849, 'HOP-LP-ETH', 18, 'receipt')
    ,(0x07ce97eb3f375901d26ec1e32144292318839802, 'HOP-LP-WBTC', 18, 'receipt')
    ,(0x60daec2fc9d2e0de0577a5c708bcadba1458a833, 'bathDAI', 18, 'receipt') --rubicon receipt token
    ,(0xb0be5d911e3bd4ee2a8706cf1fac8d767a550497, 'bathETH', 18, 'receipt')
    ,(0x7571cc9895d8e997853b1e0a1521ebd8481aa186, 'bathWBTC', 18, 'receipt')
    ,(0xe0e112e8f33d3f437d1f895cbb1a456836125952, 'bathUSDC', 18, 'receipt')
    ,(0xffbd695bf246c514110f5dae3fa88b8c2f42c411, 'bathUSDT', 18, 'receipt')
    ,(0xeb5f29afaaa3f44eca8559c3e8173003060e919f, 'bathSNX', 18, 'receipt')
    ,(0x8f69783db37905f026cf62223c9957ae0ca90a38, 'UEPC', 0, 'underlying')
    ,(0x96db852d93c2fea0f447d6ec22e146e4e09caee6, 'JPYC', 18, 'underlying')
    ,(0x8f69ee043d52161fd29137aedf63f5e70cd504d5, 'DOG', 18, 'underlying')
    ,(0x11b6b63515ab0d04a4b28a316486820cf5012ddf, 'f6-USDC', 18, 'receipt')
    ,(0x7c17611ed67d562d1f00ce82eebd39cb7b595472, 'THIRM', 18, 'underlying')
    ,(0xe0bb0d3de8c10976511e5030ca403dbf4c25165b, '0xBTC', 8, 'underlying')
    ,(0xb04095d45a98dbda07564d124b3cdb7f0d88c696, 'Demo', 18, 'underlying')
    ,(0x588abc030b08819c4c284189ce269a8fb4efe439, 'quotMKRquot', 18, 'underlying')
    ,(0xe3c332a5dce0e1d9bc2cc72a68437790570c28a4, 'VEE', 18, 'underlying')
    ,(0xb27e3eab7526bf721ea8029bfcd3fdc94c4f8b5b, 'ODOGE', 18, 'underlying')
    ,(0xdeaddeaddeaddeaddeaddeaddeaddeaddead0000, 'ETH', 18, 'underlying')
    ,(0x9bcef72be871e61ed4fbbc7630889bee758eb81d, 'rETH', 18, 'underlying')
    ,(0xc40f949f8a4e094d1b49a23ea9241d289b7b2819, 'LUSD', 18, 'underlying')
    ,(0xe88d846b69020680b2deeea58511636250c42707, 'OVM-TEST', 18, 'underlying')
    ,(0xf98dcd95217e15e05d8638da4c91125e59590b07, 'KROM', 18, 'underlying')
    ,(0xc7b04dc5a2644522a0c58c107346b5e3a63600b0, 'SACRO', 18, 'underlying')
    ,(0x7c6b91d9be155a6db01f749217d76ff02a7227f2, 'SACRO', 18, 'underlying')
    ,(0x5a5fff6f753d7c11a56a52fe47a177a87e431655, 'SYN', 18, 'underlying')
    ,(0x809dc529f07651bd43a172e8db6f4a7a0d771036, 'nETH', 18, 'underlying') --synapse swap
    ,(0x65559aa14915a70190438ef90104769e5e890a00, 'ENS', 18, 'underlying')
    ,(0x00f932f0fe257456b32deda4758922e56a4f4b42, 'PAPER', 18, 'underlying')
    ,(0x0a03498ec169247f81761d9b67bf5b206ff0c0fc, 'vBTC', 18, 'na') --perp virtual token
    ,(0x121ab82b49b2bc4c7901ca46b8277962b4350204, 'WETH', 18, 'underlying')
    ,(0x1259adc9f2a0410d0db5e226563920a2d49f4454, 'WETH', 18, 'underlying')
    ,(0x23b5b8cc1ad8ca333c817bc2e3d842e4cb90cc48, 'nETH-LP', 18, 'receipt')
    ,(0x28d8a1a6bdeaf9d42da6a55da8a34710e3434b97, 'vETH', 18, 'na') --perp virtual token
    ,(0x4619a06ddd3b8f0f951354ec5e75c09cd1cd1aef, 'nETH-LP', 18, 'receipt')
    ,(0x48a5322c3021d5ed5ce4293112141045d12c7efc, 'pWBTC', 8, 'receipt') --wepiggy
    ,(0x64b18e6d7b4693f86aa12c1724f1e195232bf044, 'vBTC', 18, 'na') --perp virtual token
    ,(0x68d97b7a961a5239b9f911da8deb57f6ef6e5e28, 'TLP', 18, 'underlying')
    ,(0x811cd5cb4cc43f44600cfa5ee3f37a402c82aec2, 'pUSDC', 8, 'receipt') --wepiggy
    ,(0xbe4a5438ad89311d8c67882175d0ffcc65dc9c03, 'BORING', 18, 'underlying')
    ,(0xc12b9d620bfcb48be3e0ccbf0ea80c717333b46f, 'pDAI', 8, 'receipt') --wepiggy
    ,(0xdb21bb0389b616bb2ebde855975df4f2ce9fb74f, 'vUSD', 18, 'na') --perp virtual token
    ,(0xe402d5eef58aad816d7240e50f20922f53a81711, 'vUSD', 18, 'na') --perp virtual token
    ,(0x5029c236320b8f15ef0a657054b84d90bfbeded3, 'bitANT', 18, 'underlying')
    ,(0xc98b98d17435aa00830c87ea02474c5007e1f272, 'bitBTC', 18, 'underlying')
    ,(0x14cd3bd06d6ea144840db5d85607492a5ae6fb38, 'Poly-Peg NB', 6, 'na') --unknown token
    ,(0x8158b34ff8a36dd9e4519d62c52913c24ad5554b, 'pUSDT', 8, 'receipt') --wepiggy
    ,(0x8a48fd91596b905e0309ba524ad5901498b325cf, 'LP-USDT', 8, 'receipt') --hop
    ,(0xa27a0a67c0ff095d19c5333be0c604d622466279, 'LP-USDC', 18, 'receipt') --hop
    ,(0x8e1e582879cb8bac6283368e8ede458b63f499a5, 'pETH', 8, 'receipt') --wepiggy
    ,(0x8f00a5e13b3f2aaaddc9708ad5c77fbcc300b0ee, 'pLINK', 8, 'receipt') --wepiggy
    ,(0x9413b54f04c90ed8eb59a08323d767b72dcd278e, 'WETH', 18, 'underlying')
    ,(0xab3f8a9599d62f09a71d7337dfff4458a4c7fe27, 'vETH', 18, 'na') --perp virtual token
    ,(0xc84da6c8ec7a57cd10b939e79eaf9d2d17834e04, 'vUSD', 18, 'na') --perp virtual token
    ,(0x8c835dfaa34e2ae61775e80ee29e2c724c6ae2bb, 'vETH', 18, 'na') --perp virtual token
    ,(0x86f1e0420c26a858fc203A3645dD1A36868F18e5, 'vBTC', 18, 'na') --perp virtual token
    ,(0x81b875688b8d134d22c52068c0cca5dcdb6cd66d, 'pKratos', 18, 'underlying')
    ,(0xa7a084538de04d808f20c785762934dd5da7b3b4, 'iETH', 18, 'receipt') --dforce borrow token
    ,(0xb344795f0e7cf65a55cb0dde1e866d46041a2cc2, 'iUSDC', 6, 'receipt') --dforce borrow token
    ,(0x5bede655e2386abc49e2cc8303da6036bf78564c, 'iDAI', 18, 'receipt') --dforce borrow token
    ,(0x30adf434dc6d586526efc3e7ea3b4550b2be7456, 'FNDR', 18, 'underlying')
    ,(0x50c5725949a6f0c72e6c4a641f24049a917db0cb, 'LYRA', 18, 'underlying')
    ,(0x89b7fda54019e62b4faf44777a0d0e85bd9c4ad3, 'Kratos', 9, 'underlying')
    ,(0xb48b36ea8dfd6113bdf7339e7ef344d0b3f9878f, 'BUZZ', 18, 'underlying')
    ,(0x1da650c3b2daa8aa9ff6f661d4156ce24d08a062, 'DCN', 0, 'underlying')
    ,(0xa807d4bc69b050b8d0c99542cf93903c2efe8b4c, 'OptiNYAN', 18, 'underlying')
    ,(0xe7798f023fc62146e8aa1b36da45fb70855a77ea, 'UMA', 18, 'underlying')
    ,(0xbfd291da8a403daaf7e5e9dc1ec0aceacd4848b9, 'USX', 18, 'underlying')
    ,(0x780f70882ff4929d1a658a4e8ec8d4316b24748a, 'vAELIN', 18, 'underlying') --Pool purchase token
    ,(0x6f620ec89b8479e97a6985792d0c64f237566746, 'WPC', 18, 'underlying')
    ,(0x6b7413c45980d506993116590b8d25e76d1ab731, 'ODOG', 18, 'underlying')
    ,(0x3e7ef8f50246f725885102e8238cbba33f276747, 'BOND', 18, 'underlying')
    ,(0x9e1028f5f1d5ede59748ffcee5532509976840e0, 'PERP', 18, 'underlying')
    ,(0x61baadcf22d2565b0f471b291c475db5555e0b76, 'AELIN', 18, 'underlying')
    ,(0x2250b4ed46b7d0a71c91da173b52555b9cc21e59, 'CHEESE', 18, 'underlying')
    ,(0xfa436399d0458dbe8ab890c3441256e3e09022a8, 'ZIP', 18, 'underlying')
    ,(0x18172f6604136041f603270790a437342b9ba57f, 'Kratos', 18, 'underlying')
    ,(0x2e3d870790dc77a83dd1d18184acc7439a53f475, 'FRAX', 18, 'underlying')
    ,(0xba6a2fa321bb06d668c5192be77428106c5c01e5, 'SOLUNAVAX', 18, 'underlying')
    ,(0xcfd1d50ce23c46d3cf6407487b2f8934e96dc8f9, 'SPANK', 18, 'underlying')
    ,(0x3390108e913824b8ead638444cc52b9abdf63798, 'MASK', 18, 'underlying')
    ,(0x217d47011b23bb961eb6d93ca9945b7501a5bb11, 'THALES', 18, 'underlying')
    ,(0x34dccfd0083259cdbc80bab5dd53234c7af2b841, 'sKratos', 9, 'underlying')
    ,(0xb54fa166d4b88b0478f299d5854ad9b94b3feff3, 'ArbiNYAN', 18, 'underlying')
    ,(0x78b1bd624791eb8aff5f0724ac2c3539142108bf, 'ZINU', 18, 'underlying')
    ,(0xaf9fe3b5ccdae78188b1f8b9a49da7ae9510f151, 'DHT', 18, 'underlying')
    ,(0xba28feb4b6a6b81e3f26f08b83a19e715c4294fd, 'UST', 6, 'underlying')
    ,(0xfb21b70922b9f6e3c6274bcd6cb1aa8a0fe20b80, 'UST', 6, 'underlying')
    ,(0x6789d8a7a7871923fc6430432a602879ecb6520a, 'vKWENTA', 18, 'underlying')
    ,(0xa279959f0a357c2c8d961056bdb74a952d44ef67, 'slPega', 18, 'underlying')
    ,(0x8b2f7ae8ca8ee8428b6d76de88326bb413db2766, 'sSOL', 18, 'underlying')
    ,(0x45c55bf488d3cb8640f12f63cbedc027e8261e79, 'SDS', 18, 'underlying')
    ,(0x333b1ea429a88d0dd48ce7c06c16609cd76f43a8, 'vSAND', 18, 'na')
    ,(0x2f198182ec54469195a4a06262a9431a42462373, 'vLINK', 18, 'na')
    ,(0x77d0cc9568605bfff32f918c8ffaa53f72901416, 'vONE', 18, 'na')
    ,(0x5f714b5347f0b5de9f9598e39840e176ce889b9c, 'vATOM', 18, 'na')
    ,(0x5faa136fc58b6136ffdaeaac320076c4865c070f, 'vAVAX', 18, 'na')
    ,(0x151bb01c79f4516c233948d69dae39869bccb737, 'vSOL', 18, 'na')
    ,(0xb24f50dd9918934ab2228be7a097411ca28f6c14, 'vLUNA', 18, 'na')
    ,(0x18607adc70d68e196d12019d49b0607b99312853, 'PEGA', 9, 'underlying')
    ,(0x67ccea5bb16181e7b4109c9c2143c24a1c2205be, 'FXS', 18, 'underlying')
    ,(0x76fb31fb4af56892a25e32cfc43de717950c9278, 'AAVE', 18, 'underlying')
    ,(0x7161c3416e08abaa5cd38e68d9a28e43a694e037, 'vCRV', 18, 'na')
    ,(0x3fb3282e3ba34a0bff94845f1800eb93cc6850d4, 'vNEAR', 18, 'na')
    ,(0x2db8d2db86ca3a4c7040e778244451776570359b, 'vFTM', 18, 'na')
    ,(0x0b5740c6b4a97f90ef2f0220651cca420b868ffb, 'gOHM', 18, 'underlying')
    ,(0x10010078a54396f62c96df8532dc2b4847d47ed3, 'HND', 18, 'underlying')
    ,(0x1f8e8472e124f58b7f0d2598eae3f4f482780b09, 'veHND', 18, 'receipt')
    ,(0x7eada83e15acd08d22ad85a1dce92e5a257acb92, 'vFLOW', 18, 'na')
    ,(0xb6599bd362120dc70d48409b8a08888807050700, 'vBNB', 18, 'na')
    ,(0xb2b42b231c68cbb0b4bf2ffebf57782fd97d3da4, 'sAVAX', 18, 'underlying')
    ,(0x81ddfac111913d3d5218dea999216323b7cd6356, 'sMATIC', 18, 'underlying')
    ,(0x00b8d5a5e1ac97cb4341c4bc4367443c8776e8d9, 'sAAVE', 18, 'underlying')
    ,(0xf5a6115aa582fd1beea22bc93b7dc7a785f60d03, 'sUNI', 18, 'underlying')
    ,(0xfbc4198702e81ae77c06d58f81b629bdf36f0a71, 'sEUR', 18, 'underlying')
    ,(0x6b5a75f38bea1ef59bc43a5d9602e77bcbe65e46, 'TCAP', 18, 'underlying')
    ,(0x296f55f8fb28e498b858d0bcda06d955b2cb3f97, 'STG', 18, 'underlying')
    ,(0xe4f27b04cc7729901876b44f4eaa5102ec150265, 'XCHF', 18, 'underlying')
    ,(0x8a466b97c6ac3379ccc3b2776d310fd4769f550e, 'STREETCRED', 18, 'underlying')
    ,(0x522439fb1da6db24f18baab1782486b55fe3a7b6, 'AVAX1X', 18, 'underlying')
    ,(0x95fffb13856d2be739a862f9b645573e5c838bdd, 'SOL1X', 18, 'underlying')
    ,(0x19f0622903a977a24bb47521732e6291002a4ede, 'LUNA1X', 18, 'underlying')
    ,(0x514832a97f0b440567055a73fe03aa160017b990, 'SOCKS', 18, 'underlying')
    ,(0x9482aafdced6b899626f465e1fa0cf1b1418d797, 'vPERP', 18, 'na')
    ,(0xbe5de48197fc974600929196239e264ecb703ee8, 'vMATIC', 18, 'na')
    ,(0x34235c8489b06482a99bb7fcab6d7c467b92d248, 'vAAVE', 18, 'na')
    ,(0x9d34f1d15c22e4c0924804e2a38cbe93dfb84bc2, 'vAPE', 18, 'na')
    ,(0xdfa46478f9e5ea86d57387849598dbfb2e964b02, 'MAI', 18, 'underlying')
    ,(0x3f56e0c36d275367b8c502090edf38289b3dea0d, 'QI', 18, 'underlying')
    ,(0x4200000000000000000000000000000000000042, 'OP', 18, 'underlying')
    ,(0xeeeeeb57642040be42185f49c52f7e9b38f8eeee, 'ELK', 18, 'underlying')
    ,(0x56613f4b8f6f3aab660dae2f80649f9f8ef381b2, 'CLC', 0, 'underlying')
    ,(0x2daba57dd495212475b438dc41c7da82ecebf155, 'CLC', 18, 'underlying')
    ,(0x0be27c140f9bdad3474beaff0a413ec7e19e9b93, 'MNYe', 18, 'receipt')
    ,(0x67c10c397dd0ba417329543c1a40eb48aaa7cd00, 'nUSD', 18, 'underlying')
    ,(0x4ac8bd1bdae47beef2d1c6aa62229509b962aa0d, 'ETHx', 18, 'receipt')
    ,(0x83ed2ee1e2744d27ffd949314f4098f13535292f, 'LOOC', 0, 'underlying')
    ,(0x0994206dfe8de6ec6920ff4d779b0d950605fb53, 'CRV', 18, 'underlying')
    ,(0x703d57164ca270b0b330a87fd159cfef1490c0a5, 'WAD', 18, 'underlying')
    ,(0x3c8b650257cfb5f272f799f5e2b4e65093a11a05, 'VELO', 18, 'underlying')
    ,(0xfe8b128ba8c78aabc59d4c64cee7ff28e9379921, 'BAL', 18, 'underlying')
    ,(0x97513e975a7fa9072c72c92d8000b0db90b163c5, 'BEETS', 18, 'underlying')
    ,(0xcb8fa9a76b8e203d8c3797bf438d8fb81ea3326a, 'alUSD', 18, 'underlying')
    ,(0x3e29d3a9316dab217754d13b28646b76607c5f04, 'alETH', 18, 'underlying')
    ,(0x8ae125e8653821e851f12a49f7765db9a9ce7384, 'DOLA', 18, 'underlying')
    ,(0x1eba7a6a72c894026cd654ac5cdcf83a46445b08, 'GTC', 18, 'underlying')
    ,(0x6bea356b8a7004f625f803b3db4d8d258c113c84, 'dcBETH', 18, 'receipt')
    ,(0x81ab7e0d570b01411fcc4afd3d50ec8c241cb74b, 'EQZ', 18, 'underlying')
    ,(0x117cfd9060525452db4a34d51c0b3b7599087f05, 'GYSR', 18, 'underlying')
    ,(0xfeaa9194f9f8c1b65429e31341a103071464907e, 'LRC', 18, 'underlying')
    ,(0xf390830DF829cf22c53c8840554B98eafC5dCBc2, 'anyUSDC', 6, 'receipt')
    ,(0x965f84d915a9efa2dd81b653e3ae736555d945f4, 'anyWETH', 18, 'receipt')
    ,(0x1ccca1ce62c62f7be95d4a67722a8fdbed6eecb4, 'Multichain alETH', 18, 'underlying')
    ,(0x922D641a426DcFFaeF11680e5358F34d97d112E1, 'anyFXS', 18, 'underlying')
    ,(0xa3A538EA5D5838dC32dde15946ccD74bDd5652fF, 'sINR', 18, 'underlying')
    ,(0xEe9801669C6138E84bD50dEB500827b776777d28, 'O3', 18, 'underlying')
    ,(0xb12c13e66AdE1F72f71834f2FC5082Db8C091358, 'ROOBEE', 18, 'underlying')
    ,(0xC22885e06cd8507c5c74a948C59af853AEd1Ea5C, 'USDD', 18, 'underlying')
    ,(0xd6909e9e702024eb93312B989ee46794c0fB1C9D, 'BICO', 18, 'underlying')
    ,(0x62BB4fc73094c83B5e952C2180B23fA7054954c4, 'PTaOptUSDC', 6, 'receipt')
    ,(0x375488F097176507e39B9653b88FDc52cDE736Bf, 'TAROT', 18, 'underlying')
    ,(0xD1917629B3E6A72E6772Aab5dBe58Eb7FA3C2F33, 'ZRX', 18, 'underlying')
    ,(0x395ae52bb17aef68c2888d941736a71dc6d4e125, 'POOL', 18, 'underlying')
    ,(0x7113370218f31764C1B6353BDF6004d86fF6B9cc, 'USDD', 18, 'underlying')
    ,(0xcB59a0A753fDB7491d5F3D794316F1adE197B21E, 'TUSD', 18, 'underlying')
    ,(0xd8f365c2c85648f9b89d9f1bf72c0ae4b1c36cfd, 'TheDAO', 18, 'underlying')
    ,(0x374Ad0f47F4ca39c78E5Cc54f1C9e426FF8f231A, 'PREMIA', 18, 'underlying')
    ,(0x6ca558bd3eaB53DA1B25aB97916dd14bf6CFEe4E, 'pETHo', 18, 'underlying')
    ,(0x00a35FD824c717879BF370E70AC6868b95870Dfb, 'IB', 18, 'underlying')
    ,(0x09448876068907827ec15F49A8F1a58C70b04d45, 'sETHo', 18, 'underlying')
    ,(0x7aE97042a4A0eB4D1eB370C34BfEC71042a056B7, 'UNLOCK', 18, 'underlying')
    ,(0xef6301da234fc7b0545c6e877d3359fe0b9e50a4, 'SUKU', 18, 'underlying')
    ,(0x676f784d19c7F1Ac6C6BeaeaaC78B02a73427852, 'OPP', 18, 'underlying')
    ,(0xe4dE4B87345815C71aa843ea4841bCdc682637bb, 'BUILD', 18, 'underlying')
    ,(0x66e8617d1Df7ab523a316a6c01D16Aa5beD93681, 'SHACK', 18, 'underlying')
    ,(0xf899e3909B4492859d44260E1de41A9E663e70F5, 'RADIO', 18, 'underlying')
    ,(0x73cb180bf0521828d8849bc8CF2B920918e23032, 'USD+', 6, 'underlying')
    ,(0xc3864f98f2a61A7cAeb95b039D031b4E2f55e0e9, 'OpenX', 18, 'underlying')
    ,(0x1DB2466d9F5e10D7090E7152B68d62703a2245F0, 'SONNE', 18, 'underlying')
    ,(0x1eC50880101022C11530A069690F5446d1464592, 'USDy', 18, 'receipt')
    ,(0x59bAbc14Dd73761e38E5bdA171b2298DC14da92d, 'dSNX', 18, 'receipt')
    ,(0x4E720DD3Ac5CFe1e1fbDE4935f386Bb1C66F4642, 'BIFI', 18, 'underlying')
    ,(0xa5974bd897B48C957CC7Cd93DB680045315d596d, 'OPrint', 18, 'underlying')
    ,(0x2513486f18eee1498d7b6281f668b955181dd0d9, 'xOpenx', 18, 'underlying')
    ,(0x39d36cF934aAE9Fcf4c5112648a016B8A7127B35, 'dETH', 18, 'underlying')
    ,(0xB153FB3d196A8eB25522705560ac152eeEc57901, 'MIM', 18, 'underlying')
    ,(0x1F32b1c2345538c0c6f582fCB022739c4A194Ebb, 'wstETH', 18, 'underlying')
    ,(0xFdb794692724153d1488CcdBE0C56c252596735F, 'LDO', 18, 'underlying')
    ,(0xd52f94df742a6f4b4c8b033369fe13a41782bf44, 'L2DAO', 18, 'underlying')
    ,(0x85f6583762bc76d775eab9a7456db344f12409f7, 'renBTC', 8, 'underlying')
    ,(0xde48b1b5853cc63b1d05e507414d3e02831722f8, 'stkLYRA', 18, 'receipt')
    ,(0x0f5d45a7023612e9e244fe84fac5fcf3740d1492, 'stkLYRA', 18, 'receipt')
    ,(0x9e5aac1ba1a2e6aed6b32689dfcf62a509ca96f3, 'DF', 18, 'underlying')
    ,(0x9485aca5bbbe1667ad97c7fe7c4531a624c8b1ed, 'agEUR', 18, 'underlying')
    ,(0xAe31207aC34423C41576Ff59BFB4E036150f9cF7, 'SDL', 18, 'underlying')
    ,(0x39FdE572a18448F8139b7788099F0a0740f51205, 'OATH', 18, 'underlying')
    ,(0xc5102fE9359FD9a28f877a67E36B0F050d81a3CC, 'HOP', 18, 'underlying')
    ,(0xB0B195aEFA3650A6908f15CdaC7D92F8a5791B0B, 'BOB', 18, 'underlying')
    ,(0x86bEA60374f220dE9769b2fEf2db725bc1cDd335, 'FLASH', 18, 'underlying')
    ,(0xec6adef5e1006bb305bb1975333e8fc4071295bf, 'CTSI', 18, 'underlying')
    ,(0x0e49ca6ea763190084c846d3fc18f28bc2ac689a, 'DUCK', 18, 'underlying')
    ,(0x50bce64397c75488465253c0a034b8097fea6578, 'HAN', 18, 'underlying')
    ,(0xe3ab61371ecc88534c522922a026f2296116c109, 'SPELL', 18, 'underlying')
    ,(0x29FAF5905bfF9Cfcc7CF56a5ed91E0f091F8664B, 'BANK', 18, 'underlying')
    ,(0x920Cf626a271321C151D027030D5d08aF699456b, 'KWENTA', 18, 'underlying')
    ,(0xcdb4bb51801a1f399d4402c61bc098a72c382e65, 'OPX', 18, 'underlying')
    ,(0x479a7d1fcdd71ce0c2ed3184bfbe9d23b92e8337, 'bb-rf-aUSD-asUSD', 18, 'receipt')
    ,(0x6222ae1d2a9f6894da50aa25cb7b303497f9bebd, 'bb-rf-aUSD', 18, 'receipt')
    ,(0xc0d7013a05860271a1edb52415cf74bc85b2ace7, 'bb-rf-asUSD', 18, 'receipt')
    ,(0x7d6bff131b359da66d92f215fd4e186003bfaa42, 'BPT-USD+', 18, 'receipt')
    ,(0x75441c125890612f95b5fbf3f73db0c25f5573cd, 'rf-a-DAI', 18, 'receipt')
    ,(0xa348700745d249c3b49d2c2acac9a5ae8155f826, 'wUSD+', 6, 'receipt')
    ,(0x61cbcb4278d737471ee54dc689de50e4455978d8, 'rf-a-USDT+', 18, 'receipt')
    ,(0x9964b1bd3cc530e5c58ba564e45d45290f677be2, 'test-bb-rf-a-USD', 18, 'receipt')
    ,(0xce9329f138cd6319fcfbd8704e6ae50b6bb04f31, 'bb-rf-aDAI', 18, 'receipt')
    ,(0x15873081c0aa67ad5c5dba362169d352e2a128a2, 'bb-rf-aUSDC', 18, 'receipt')
    ,(0x43cb769d5647cc56f5c1e8df72ab9097dab59cce, 'rf-a-WBTC', 18, 'receipt')
    ,(0x0b8f31480249cc717081928b8af733f45f6915bb, 'wDAI+', 18, 'receipt')
    ,(0x7ecc9d0ee071c7b86d0ae2101231a3615564009e, 'rf-a-USDC', 18, 'receipt')
    ,(0x21f95cff4aa2e1dd8f43c6b581f246e5aa67fc9c, 'rf-grain-BAL', 18, 'receipt')
    ,(0xdf2d2c477078d2cd563648abbb913da3db247c00, 'rf-a-WETH', 18, 'receipt')
    ,(0x88d07558470484c03d3bb44c3ecc36cafcf43253, 'bb-USD+', 18, 'receipt')
    ,(0xf572649606db4743d217a2fa6e8b8eb79742c24a, 'test-bb-USD-MAI', 18, 'receipt')
    ,(0xdd89c7cd0613c1557b2daac6ae663282900204f1, 'bb-rf-aWETH', 18, 'receipt')
    ,(0x018a1e566c0847e35e7d46e4ee0428c35574a3d8, 'OD', 18, 'underlying')
    ,(0x7fe67173e14aa3349b8f24533084379e1066e19c, 'OD', 18, 'underlying')
    ,(0xa00e3a3511aac35ca78530c85007afcd31753819, 'KNC',18, 'underlying')
    ,(0x96f2539d3684dbde8b3242a51a73b66360a5b541, 'USDL', 18, 'underlying')
    ,(0x2297aebd383787a160dd0d9f71508148769342e3, 'BTC.b', 8, 'underlying')
    ,(0x3417e54a51924c225330f8770514ad5560b9098d, 'RED', 18, 'underlying')
    ,(0x6f0fecbc276de8fc69257065fe47c5a03d986394, 'POP', 18, 'underlying')
    ,(0x1a9c8b7f8695abd9a930ea49a498ce1b7a590d25, 'ABT', 18, 'underlying')
    ,(0x0c5b4c92c948691EEBf185C17eeB9c230DC019E9, 'PICKLE', 18, 'underlying')
    ,(0xB0ae108669CEB86E9E98e8fE9e40d98b867855fD, 'RING', 18, 'underlying')
    ,(0xe50fa9b3c56ffb159cb0fca61f5c9d750e8128c8, 'aOptWETH', 18, 'receipt')
    ,(0x625e7708f30ca75bfd92586e17077590c60eb4cd, 'aOptUSDC', 6, 'receipt')
    ,(0x6ab707aca953edaefbc4fd23ba73294241490620, 'aOptUSDT', 6, 'receipt')
    ,(0xf329e36c7bf6e5e86ce2150875a84ce77f477375, 'aOptAAVE', 18, 'receipt')
    ,(0x82e64f49ed5ec1bc6e43dad4fc8af9bb3a2312ee, 'aOptDAI', 18, 'receipt')
    ,(0x191c10aa4af7c30e871e70c95db0e4eb77237530, 'aOptLINK', 18, 'receipt')
    ,(0x6d80113e533a2c0fe82eabd35f1875dcea89ea97, 'aOptSUSD', 18, 'receipt')
    ,(0x078f358208685046a11c85e8ad32895ded33a249, 'aOptWBTC', 8, 'receipt')
    ,(0x513c7E3a9c69cA3e22550eF58AC1C0088e918FFf, 'aOptOP', 18, 'receipt')
    ,(0x74ccbe53F77b08632ce0CB91D3A545bF6B8E0979, 'fBOMB', 18, 'underlying')
    ,(0x9C9e5fD8bbc25984B178FdCE6117Defa39d2db39, 'BUSD', 18, 'underlying')
    ,(0xb12a1be740b99d845af98098965af761be6bd7fe, 'CUSDCLP', 18, 'receipt')
    ,(0x3c12765d3cfac132de161bc6083c886b2cd94934, 'CWETHLP', 18, 'receipt') 
    ,(0x6806411765Af15Bddd26f8f544A34cC40cb9838B, 'frxETH', 18, 'underlying')
    ,(0x484c2D6e3cDd945a8B2DF735e079178C1036578c, 'sfrxETH', 18, 'receipt')
    ,(0x340fE1D898ECCAad394e2ba0fC1F93d27c7b717A, 'wUSDR', 9, 'underlying')
    ,(0x5d47baba0d66083c52009271faf3f50dcc01023c, 'UNIDX', 18, 'underlying')
    ,(0x46f21fda29f1339e0ab543763ff683d399e393ec, 'opxveVELO', 18, 'receipt')
    ,(0x79af5dd14e855823fa3e9ecacdf001d99647d043, 'jEUR', 18, 'underlying')
    ,(0x8B21e9b7dAF2c4325bf3D18c1BeB79A347fE902A, 'COLLAB', 18, 'underlying')
    ,(0xc96f4F893286137aC17e07Ae7F217fFca5db3AB6, 'NFTE', 18, 'underlying')
    ,(0xd652776dE7Ad802be5EC7beBfafdA37600222B48, 'SLM', 18, 'underlying')
    ,(0x840b25c87B626a259CA5AC32124fA752F0230a72, 'LZ-agEUR', 18, 'receipt')
    ,(0xedcfaf390906a8f91fb35b7bac23f3111dbaee1c, 'bb-rf-soUSDC', 18, 'receipt')
    ,(0xaddb6a0412de1ba0f936dcaeb8aaa24578dcf3b2, 'cbETH', 18, 'underlying')
    ,(0xd20f6f1d8a675cdca155cb07b5dc9042c467153f, 'bOATH', 18, 'receipt')
    ,(0xc5b001DC33727F8F26880B184090D3E252470D45, 'ERN', 18, 'underlying')
    ,(0xdecc0c09c3b5f6e92ef4184125d5648a66e35298, 'S*USDC', 18, 'receipt')
    ,(0xd22363e3762cA7339569F3d33EADe20127D5F98C, 'S*SGETH', 18, 'receipt')
    ,(0xdd69db25f6d620a7bad3023c5d32761d353d3de9, 'GETH', 18, 'na')
    ,(0x1337bedc9d22ecbe766df105c9623922a27963ec, '3CRV', 18, 'receipt')
    ,(0xfdeffc7ad816bf7867c642df7ebc2cc5554ec265, 'beVELO', 18, 'receipt')
    ,(0x86b3f23b6e90f5bbfac59b5b2661134ef8ffd255, 'anyUSDT', 6, 'receipt')
    ,(0x47536f17f4ff30e64a96a7555826b8f9e66ec468, 'MMY', 18, 'underlying')
    ,(0x0d8393cea30df4fafa7f00f333a62dee451935c1, 'esMMY', 18, 'receipt')
    ,(0x7da25bc4cfaed3f29414c6779676e53b19a356f5, 'KOKO', 18, 'underlying')
    ,(0xfd389dc9533717239856190f42475d3f263a270d, 'GRAIN', 18, 'underlying')
    ,(0x139283255069ea5deef6170699aaef7139526f1f, 'OptiDoge', 18, 'underlying')
    ,(0xf8e943f646816e4b51279b8934753821ed832dca, 'CTH', 18, 'underlying')
    ,(0x970d50d09f3a656b43e11b0d45241a84e3a6e011, 'DAI+', 18,'underlying')
    ,(0x43da214fab3315aA6c02e0B8f2BfB7Ef2E3C60A5, 'BPT-overnight-II', 18, 'receipt')
    ,(0x65e66a61d0a8f1e686c2d6083ad611a10d84d97a, 'anyMAI', 18, 'receipt')
    ,(0xb1c9ac57594e9b1ec0f3787d9f6744ef4cb0a024, 'BPT-USD+', 18, 'receipt')
    ,(0x7b50775383d3d6f0215a8f290f2c9e2eebbeceb2, 'BPT-WSTETH-WETH', 18, 'receipt')
    ,(0x739ca6d71365a08f584c8fc4e1029045fa8abc4b, 'anyDOLA', 18, 'receipt')
    ,(0xdb4ea87ff83eb1c80b8976fc47731da6a31d35e5, 'wTBT', 18, 'underlying')
    ,(0xd3594E879B358F430E20F82bea61e83562d49D48, 'PSP',  18, 'receipt')
    ,(0x764ad60e1b81f6cacfec1a2926393d688d4493e6, 'aCRV',	18, 'receipt')
    ,(0xDb9888b842408B0b8eFa1f5477bD9F351754999E, 'BAXA',	18, 'underlying')
    ,(0xCa0E54b636DB823847B29F506BFFEE743F57729D, 'CHI',	18, 'underlying')
    ,(0x7b0bcC23851bBF7601efC9E9FE532Bf5284F65d3, 'EST',	18, 'underlying')
    ,(0x3bB4445D30AC020a84c1b5A8A2C6248ebC9779D0, 'LIZ',	18, 'underlying')
    ,(0x0B3e851cf6508A16266BC68A651ea68b31ef673b, 'LPF',	18, 'underlying')
    ,(0x77D40CBc27f912dcDbF4348cAf87B427c4D02486, 'MOCHI',	18, 'underlying')
    ,(0x5e70AfFE232e2919792f77EB94e566db0320fa88, 'MOM',	18, 'underlying')
    ,(0x678d8f4Ba8DFE6bad51796351824DcCECeAefF2B, 'veKWENTA',	18, 'receipt')
    ,(0x6e4cc0Ab2B4d2eDAfa6723cFA1582229F1Dd1Be1, 'ZUSD',	6, 'underlying')
    ,(0x384fabB05F28389Afc16fC8bcB08B55eD97Fa597, 'OPepe', 18, 'underlying')
    ,(0x3Ebb31CB2888e0Acbb81cBE2FeC65AEE24be3BD4, 'AVT', 18, 'underlying')
    ,(0xc4d4500326981eacD020e20A81b1c479c161c7EF, 'exaWETH', 18, 'receipt')
    ,(0x1203cdcead2500bccd251811fd5fedb2026fb499, 'LAME', 18, 'underlying')
    ,(0x641ff5d17178c3b9498133ebc264bb4170a04668, 'bnMMY', 18, 'receipt')
    ,(0xe149164D8eca659E8912DbDEC35E3f7E71Fb5789, 'sbMMY', 18, 'receipt')
    ,(0x04f23404553fcc388Ec73110A0206Dd2E76a6d95, 'sMMY', 18, 'receipt')
    ,(0x7b26207457a9f8ff4fd21a7a0434066935f1d8e7, 'sbfMMY', 18, 'receipt')
    ,(0xffb69477fee0daeb64e7de89b57846afa990e99c, 'fMMY', 18, 'receipt')
    ,(0xcab2c0a41556149330f4223c9b76d93c610dafe6, 'MLP', 18, 'receipt')
    ,(0x01e77288b38b416F972428d562454fb329350bAc, 'USDM', 18, 'receipt')
    ,(0x2A3E489F713ab6F652aF930555b5bb3422711ac1, 'vMMY', 18, 'receipt')
    ,(0xc35457e32e6fcd8d32019d3a46bc2ecc25faab87, 'OPDOGE', 6, 'underlying')
    ,(0x67e51f46e8e14d4e4cab9df48c59ad8f512486dd, 'nextUSDC', 6, 'receipt')
    ,(0x8430F084B939208E2eDEd1584889C9A66B90562f, 'USDCx', 18, 'receipt')
    ,(0xc26921b5b9ee80773774d36c84328ccb22c3a819, 'wOptiDoge', 18, 'receipt')
    ,(0xb69c8cbcd90a39d8d3d3ccf0a3e968511c3856a0, 'SGETH', 18, 'receipt')
    ,(0x2a9ad452af412d62eff7080c846c52bf9b1c9e91, 'anyWETH', 18, 'receipt')
    ,(0xccf3d1acf799bae67f6e354d685295557cf64761, 'vaETH', 18, 'receipt')
    ,(0x539505dde2b9771debe0898a84441c5e7fdf6bc0, 'vaUSDC', 18, 'receipt')
    ,(0x12ff4a259e14d4dcd239c447d23c9b00f7781d8f, 'PEPE Optimism', 18, 'underlying')
    ,(0xc4b60eb182720e6b6e129e9f8428ea66c1461cab, 'OptiPepe', 18, 'underlying')
    ,(0x5130f6ce257b8f9bf7fac0a0b519bd588120ed40, 'CLPRDRPL', 18, 'receipt')
    ,(0x4518231a8fdf6ac553b9bbd51bbb86825b583263, 'KNC', 18, 'underlying')
    ,(0x244766fe27507859eee05841b1ef710c84271088, 'OW', 6, 'underlying')
    ,(0xD95610e852339275A456B3f7e56934F7C00F0461, 'oerc', 18, 'underlying')
    ,(0x2885f7882b13af382481cc173a0335702f790527, 'AIWORLD', 6, 'underlying')
    ,(0x1155657c4cfb60ee9a3f3f01bf5f85bddcdab20a, 'op love', 18, 'underlying')
    ,(0x9A601C5bb360811d96A23689066af316a30c3027, 'PIKA', 18, 'underlying')
    ,(0x6019a048a40a32f29a6a077ad70e9caef2cbaf31, 'AI', 18, 'underlying')
    ,(0xa50B23cDfB2eC7c590e84f403256f67cE6dffB84, 'BLU', 18, 'underlying')
    ,(0xe4d8701c69b3b94a620ff048e4226c895b67b2c0, 'MINE', 18, 'underlying')
    ,(0x19ca00d242e96a30a1cad12f08c375caa989628f, 'rf-so-DAI', 18, 'receipt')
    ,(0x122C5CEa45AB319dc3E8425087867bdE7d38B63B, 'oercCASH', 18, 'underlying')
    ,(0xcfc9BD00Bc8e4893b5a00f3154C3Ac091AC2E4b8, 'KERM', 18, 'underlying')
    ,(0x22fa3580f997e2296a2d552be19300274ab8bd3c, 'Avd', 18, 'underlying')
    ,(0x548eedc1494ddf54c4de8d9b34030f1eb40edfe8, 'WLD', 8, 'underlying')
    ,(0x2e80259c9071b6176205ff5f5eb6f7ec8361b93f, 'HASH', 18, 'underlying')
    ,(0x1610e3c85dd44Af31eD7f33a63642012Dca0C5A5, 'msETH', 18, 'receipt')
    ,(0x9a2e53158e12BC09270Af10C16A466cb2b5D7836, 'MET', 18, 'underlying')
    ,(0xB25EA095997F5bBaa6cEa962c4fBf3bfc3C09776, 'FIRE', 9, 'underlying')
    ,(0x6c84a8f1c29108F47a79964b5Fe888D4f4D0dE40, 'tBTC', 18, 'underlying')
    ,(0x747e42Eb0591547a0ab429B3627816208c734EA7, 'T', 18, 'underlying')
    ,(0x1509706a6c66CA549ff0cB464de88231DDBe213B, 'AURA', 18, 'underlying')
    ,(0x0346c32E5d7e98bD57100b6F7002a0Ae17188048, 'BWLD', 18, 'underlying')
    ,(0x8a6039fc7a479928b1d73f88040362e9c50db275, 'BITCOIN (hpos10i)', 8, 'underlying')
    ,(0xe7BC9b3A936F122f08AAC3b1fac3C3eC29A78874, 'ECO', 18, 'underlying')
    ,(0x88a89866439F4C2830986B79cbe6f69d1Bd548BB, 'BIKE', 18, 'underlying')
    ,(0x2dad3a13ef0c6366220f989157009e501e7938f8, 'EXTRA', 18, 'underlying')
    ,(0x7d14206c937e70e19e3a5b94011faf0d5b3928e2, 'VITA', 18, 'underlying')
    ,(0xA8d83Cd5102b0A412931B12255D218B0b0E7152C, 'OPL', 18, 'underlying')
    ,(0xBB6BBaa0F6D839A00c82B10747aBc3b7E2eEcc82, 'IBEX', 18, 'underlying')
    ,(0xC27D9BC194a648fE3069955a5126699C4e49351C, 'AMKT', 18, 'receipt')
    ,(0xC5B3AC2DF8D8D7AC851F763a5b3Ff23B4A696d59, 'APT', 8, 'underlying')
    ,(0xCa98d642E158c3016E1c75dbcC3D5ECFe3E02A19, 'ETS WETH/USDC', 6, 'receipt')
    ,(0xDeBa4568ff4CC84B420bcbFb228De5b7F2807a5c, 'CHAM', 18, 'underlying')
    ,(0xb1aE0a34DC3976d98C1741C92b798dAF8E0e1e11, 'TRX', 6, 'underlying')
    ,(0xba1Cf949c382A32a09A17B2AdF3587fc7fA664f1, 'SOL', 9, 'underlying')
    ,(0xeAeAdAC73baaF4cB8B024dE9D65B2eeFa722856C, 'RFWSTETH', 18, 'underlying')
    ,(0x3a18dcc9745edcd1ef33ecb93b0b6eba5671e7ca, 'KUJI', 6,  'underlying')
    ,(0xdC6fF44d5d932Cbd77B52E5612Ba0529DC6226F1, 'WLD', 18, 'underlying')
    ,(0x894134a25a5faC1c2C26F1d8fBf05111a3CB9487, 'GRAI', 18, 'underlying')
    ,(0x0b2c639c533813f4aa9d7837caf62653d097ff85, 'USDC', 6, 'underlying')
    ,(0x14778860E937f509e651192a90589dE711Fb88a9, 'CYBER', 18, 'underlying')
    ,(0xC03b43d492d904406db2d7D57e67C7e8234bA752, 'wUSDR', 9, 'underlying')
    ,(0x9560e827aF36c94D2Ac33a39bCE1Fe78631088Db, 'VELO', 18, 'underlying')
    ,(0x1f514a61bcde34f94bc39731235690ab9da737f7, 'TAROT', 18, 'underlying')
    ,(0x5976d4c3bcfc1c5f90ab1419d7f3ddf109cea35a, 'GNODE', 18, 'underlying')
    ,(0x1e925de1c68ef83bd98ee3e130ef14a50309c01b, 'EXA', 18, 'underlying')
    ,(0xeb466342c4d449bc9f53a865d5cb90586f405215, 'axlUSDC', 6, 'underlying')
    ,(0x58b9cB810A68a7f3e1E4f8Cb45D1B9B3c79705E8, 'NEXT', 18, 'underlying')
    ,(0x28b42698caf46b4b012cf38b6c75867e0762186d, 'UNIDX', 18, 'underlying')
    ,(0x9dabae7274d28a45f0b65bf8ed201a5731492ca0, 'msUSD', 18, 'underlying')
    ,(0x8901cb2e82cc95c01e42206f8d1f417fe53e7af0, 'YFX', 18, 'receipt')
    ,(0x385719545Ef34d457A88e723504544A53F0Ad9BC, 'MMY', 18, 'underlying')
    ,(0x33bCa143d9b41322479E8d26072a00a352404721, 'msOP', 18, 'underlying')
    ,(0x03e5b5930f3a42b56af4a982b10e60957bdd2f61, 'D2D', 18, 'underlying')
    ,(0x629c2fd5d5f432357465b59d7832389a89956f0b, 'COC', 18, 'underlying')
    ,(0x6c518f9D1a163379235816c543E62922a79863Fa, 'bwAJNA', 18, 'underlying')
    ,(0x76c37F9949e05b37C8373d155C1Fef46a6858481, 'ePendle', 18, 'underlying')
    ,(0x8368Dca5CE2a4Db530c0F6e535d90B6826428Dee, 'FPIS', 18, 'underlying')
    ,(0x8637725aDa78db0674a679CeA2A5e0A0869EF4A1, 'NFTE', 18, 'underlying')
    ,(0x96bBD55479e9923512dcc95Eb7Df5edDe6FB9874, 'wOpenX', 18, 'underlying')
    ,(0xAd42D013ac31486B73b6b059e748172994736426, '1INCH', 18, 'underlying')
    ,(0xC52D7F23a2e460248Db6eE192Cb23dD12bDDCbf6, 'crvUSD', 18, 'underlying')
    ,(0xa925f4057d6E6C8FAf8bdE537Ad14BA91A1D0337, 'SYNTH', 18, 'underlying')
    ,(0xaf3A6f67Af1624d3878A8d30b09FAe7915DcA2a0, 'EQB', 18, 'underlying')
    ,(0xc5d43a94e26fca47a9b21cf547ae4aa0268670e1, 'FPI', 18, 'underlying')
    ,(0xc871cCf95024eFa2CbcE69B5B775D2a1DcF49c1B, 'GROW', 18, 'underlying')
    ,(0x9046D36440290FfDE54FE0DD84Db8b1CfEE9107B, 'YFI', 18, 'underlying')
    ,(0xeB585163DEbB1E637c6D617de3bEF99347cd75c8, 'opXEN', 18, 'underlying')
    ,(0xdbc3a41578bBfA47837a9cD8196a5Bc7F44c8041, 'BULL', 18, 'underlying')
    ,(0x323665443CEf804A3b5206103304BD4872EA4253, 'USDV', 6, 'underlying')
    ,(0x61445Ca401051c86848ea6b1fAd79c5527116AA1, 'MO', 4, 'underlying')
    ,(0x20279b6d57Ba6D3eF852f34800e43e39d46d6487, 'MERK', 18, 'underlying')
    ,(0x9cfB13E6c11054ac9fcB92BA89644F30775436e4, 'axl-wstETH', 18, 'underlying')
    ,(0xc55E93C62874D8100dBd2DfE307EDc1036ad5434, 'mooBIFI', 18, 'receipt')
    ,(0x3ee6107d9c93955acbb3f39871d32b02f82b78ab, 'stERN', 18, 'underlying')
    ,(0x2dd1b4d4548accea497050619965f91f78b3b532, 'sFRAX', 18, 'underlying')
    ,(0x3b08fcd15280e7b5a6e404c4abb87f7c774d1b2e, 'OVN', 18, 'underlying')
    ,(0xe05a08226c49b636acf99c40da8dc6af83ce5bb3, 'ankrETH', 18, 'underlying')
    ,(0x00e1724885473b63bce08a9f0a52f35b0979e35a, 'OATH', 18, 'underlying')
    ) AS temp_table (contract_address, symbol, decimals, token_type)
)
SELECT contract_address, symbol, decimals, token_type, 'manual' AS token_mapping_source
        FROM raw_token_list

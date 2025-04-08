module hello::sui_fren {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{TxContext, sender};
    use std::string::String;
    use std::vector;
    use sui::event;
    use std::option;
    use sui::coin::{Self, TreasuryCap};

    public struct SuiFren has key {
        id: UID,
        generation: u64,
        birthdate: u64,
        attributes: vector<String>,
    }

    // public struct CANDY has drop {}

    // ✅ THIS is the required one-time witness struct
    public struct SUI_FREN has drop {}

    // ✅ init must NOT be public
    fun init(otw: SUI_FREN, ctx: &mut TxContext): () {
        let (treasury_cap, metadata) = coin::create_currency(
            otw,
            9,
            b"SUI_FREN",
            b"SuiFren Candy",
            b"Candies to level up SuiFren",
            option::none(),
            ctx
        );
        transfer::public_freeze_object(metadata);

        transfer::public_transfer(treasury_cap, sender(ctx));
    }

    fun mint(treasury_cap: &mut TreasuryCap<SUI_FREN>, amount: u64 , ctx: &mut TxContext){
        coin::mint_and_transfer(treasury_cap, amount,  tx_context::sender(ctx), ctx)
    }

}

use starknet::{ContractAddress, ClassHash};
use dojo::world::IWorldDispatcher;

#[starknet::interface]
trait IERC721EnumMintBurnPreset<TState> {
    // IWorldProvider
    fn world(self: @TState,) -> IWorldDispatcher;

    // ISRC5
    fn supports_interface(self: @TState, interface_id: felt252) -> bool;
    // ISRC5Camel
    fn supportsInterface(self: @TState, interfaceId: felt252) -> bool;

    // IERC721Metadata
    fn name(self: @TState) -> ByteArray;
    fn symbol(self: @TState) -> ByteArray;
    fn token_uri(ref self: TState, token_id: u256) -> ByteArray;
    // IERC721MetadataCamel
    fn tokenURI(self: @TState, token_id: u256) -> ByteArray;

    // IERC721Owner
    fn owner_of(self: @TState, token_id: u256) -> ContractAddress;
    // IERC721OwnerCamel
    fn ownerOf(self: @TState, token_id: u256) -> ContractAddress;

    // IERC721Balance
    fn balance_of(self: @TState, account: ContractAddress) -> u256;
    fn transfer_from(ref self: TState, from: ContractAddress, to: ContractAddress, token_id: u256);
    fn safe_transfer_from(
        ref self: TState,
        from: ContractAddress,
        to: ContractAddress,
        token_id: u256,
        data: Span<felt252>
    );
    // IERC721BalanceCamel
    fn balanceOf(self: @TState, account: ContractAddress) -> u256;
    fn transferFrom(ref self: TState, from: ContractAddress, to: ContractAddress, token_id: u256);
    fn safeTransferFrom(
        ref self: TState,
        from: ContractAddress,
        to: ContractAddress,
        token_id: u256,
        data: Span<felt252>
    );

    // IERC721Approval
    fn get_approved(self: @TState, token_id: u256) -> ContractAddress;
    fn is_approved_for_all(self: @TState, owner: ContractAddress, operator: ContractAddress) -> bool;
    fn approve(ref self: TState, to: ContractAddress, token_id: u256);
    fn set_approval_for_all(ref self: TState, operator: ContractAddress, approved: bool);
    // IERC721ApprovalCamel
    fn getApproved(self: @TState, token_id: u256) -> ContractAddress;
    fn isApprovedForAll(self: @TState, owner: ContractAddress, operator: ContractAddress) -> bool;
    fn setApprovalForAll(ref self: TState, operator: ContractAddress, approved: bool);

    // IERC721Enumerable
    fn total_supply(self: @TState) -> u256;
    fn token_by_index(self: @TState, index: u256) -> u256;
    fn token_of_owner_by_index(self: @TState, owner: ContractAddress, index: u256) -> u256;
    // IERC721EnumerableCamel
    fn totalSupply(self: @TState) -> u256;
    fn tokenByIndex(self: @TState, index: u256) -> u256;
    fn tokenOfOwnerByIndex(self: @TState, owner: ContractAddress, index: u256) -> u256;

    // ERC721EnumMintBurn
    fn initializer(
        ref self: TState,
        name: ByteArray,
        symbol: ByteArray,
        base_uri: ByteArray,
        recipient: ContractAddress,
        token_ids: Span<u256>
    );
    fn mint(ref self: TState, to: ContractAddress, token_id: u256);
    fn burn(ref self: TState, token_id: u256);

    fn dojo_resource(self: @TState,) -> felt252;
}

#[starknet::interface]
trait IERC721EnumInit<TState> {
    fn initializer(
        ref self: TState,
        name: ByteArray,
        symbol: ByteArray,
        base_uri: ByteArray,
        recipient: ContractAddress,
        token_ids: Span<u256>
    );
}

#[starknet::interface]
trait IERC721EnumMintBurn<TState> {
    fn mint(ref self: TState, to: ContractAddress, token_id: u256);
    fn burn(ref self: TState, token_id: u256);
}

#[dojo::contract]
mod ERC721EnumMintBurn {
    use starknet::ContractAddress;
    use starknet::{get_contract_address, get_caller_address};
    use origami_token::components::security::initializable::initializable_component;
    use origami_token::components::introspection::src5::src5_component;
    use origami_token::components::token::erc721::erc721_approval::erc721_approval_component;
    use origami_token::components::token::erc721::erc721_balance::erc721_balance_component;
    use origami_token::components::token::erc721::erc721_burnable::erc721_burnable_component;
    use origami_token::components::token::erc721::erc721_enumerable::erc721_enumerable_component;
    use origami_token::components::token::erc721::erc721_metadata::erc721_metadata_component;
    use origami_token::components::token::erc721::erc721_mintable::erc721_mintable_component;
    use origami_token::components::token::erc721::erc721_owner::erc721_owner_component;

    component!(path: initializable_component, storage: initializable, event: InitializableEvent);

    component!(path: src5_component, storage: src5, event: SRC5Event);
    component!(
        path: erc721_approval_component, storage: erc721_approval, event: ERC721ApprovalEvent
    );
    component!(path: erc721_balance_component, storage: erc721_balance, event: ERC721BalanceEvent);
    component!(
        path: erc721_burnable_component, storage: erc721_burnable, event: ERC721BurnableEvent
    );
    component!(
        path: erc721_enumerable_component, storage: erc721_enumerable, event: ERC721EnumerableEvent
    );
    component!(
        path: erc721_metadata_component, storage: erc721_metadata, event: ERC721MetadataEvent
    );
    component!(
        path: erc721_mintable_component, storage: erc721_mintable, event: ERC721MintableEvent
    );
    component!(path: erc721_owner_component, storage: erc721_owner, event: ERC721OwnerEvent);

    impl InitializableImpl = initializable_component::InitializableImpl<ContractState>;

    #[abi(embed_v0)]
    impl SRC5Impl = src5_component::SRC5Impl<ContractState>;

    #[abi(embed_v0)]
    impl SRC5CamelImpl = src5_component::SRC5CamelImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC721ApprovalImpl =
        erc721_approval_component::ERC721ApprovalImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC721ApprovalCamelImpl =
        erc721_approval_component::ERC721ApprovalCamelImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC721BalanceImpl =
        erc721_balance_component::ERC721BalanceImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC721BalanceCamelImpl =
        erc721_balance_component::ERC721BalanceCamelImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC721EnumerableImpl =
        erc721_enumerable_component::ERC721EnumerableImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC721EnumerableCamelImpl =
        erc721_enumerable_component::ERC721EnumerableCamelImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC721MetadataImpl =
        erc721_metadata_component::ERC721MetadataImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC721MetadataCamelImpl =
        erc721_metadata_component::ERC721MetadataCamelImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC721OwnerImpl = erc721_owner_component::ERC721OwnerImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC721OwnerCamelImpl = erc721_owner_component::ERC721OwnerCamelImpl<ContractState>;

    impl InitializableInternalImpl = initializable_component::InternalImpl<ContractState>;
    impl ERC721ApprovalInternalImpl = erc721_approval_component::InternalImpl<ContractState>;
    impl ERC721BalanceInternalImpl = erc721_balance_component::InternalImpl<ContractState>;
    impl ERC721BurnableInternalImpl = erc721_burnable_component::InternalImpl<ContractState>;
    impl ERC721EnumerableInternalImpl = erc721_enumerable_component::InternalImpl<ContractState>;
    impl ERC721MetadataInternalImpl = erc721_metadata_component::InternalImpl<ContractState>;
    impl ERC721MintableInternalImpl = erc721_mintable_component::InternalImpl<ContractState>;
    impl ERC721OwnerInternalImpl = erc721_owner_component::InternalImpl<ContractState>;

    mod Errors {
        const CALLER_IS_NOT_OWNER: felt252 = 'ERC721: caller is not owner';
        const INVALID_ACCOUNT: felt252 = 'ERC721: invalid account';
        const UNAUTHORIZED: felt252 = 'ERC721: unauthorized caller';
        const INVALID_RECEIVER: felt252 = 'ERC721: invalid receiver';
        const WRONG_SENDER: felt252 = 'ERC721: wrong sender';
        const SAFE_TRANSFER_FAILED: felt252 = 'ERC721: safe transfer failed';
    }

    #[storage]
    struct Storage {
        #[substorage(v0)]
        initializable: initializable_component::Storage,
        #[substorage(v0)]
        src5: src5_component::Storage,
        #[substorage(v0)]
        erc721_approval: erc721_approval_component::Storage,
        #[substorage(v0)]
        erc721_balance: erc721_balance_component::Storage,
        #[substorage(v0)]
        erc721_burnable: erc721_burnable_component::Storage,
        #[substorage(v0)]
        erc721_enumerable: erc721_enumerable_component::Storage,
        #[substorage(v0)]
        erc721_metadata: erc721_metadata_component::Storage,
        #[substorage(v0)]
        erc721_mintable: erc721_mintable_component::Storage,
        #[substorage(v0)]
        erc721_owner: erc721_owner_component::Storage,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        InitializableEvent: initializable_component::Event,
        #[flat]
        SRC5Event: src5_component::Event,
        #[flat]
        ERC721ApprovalEvent: erc721_approval_component::Event,
        #[flat]
        ERC721BalanceEvent: erc721_balance_component::Event,
        #[flat]
        ERC721BurnableEvent: erc721_burnable_component::Event,
        #[flat]
        ERC721EnumerableEvent: erc721_enumerable_component::Event,
        #[flat]
        ERC721MetadataEvent: erc721_metadata_component::Event,
        #[flat]
        ERC721MintableEvent: erc721_mintable_component::Event,
        #[flat]
        ERC721OwnerEvent: erc721_owner_component::Event,
    }

    #[abi(embed_v0)]
    impl InitializerImpl of super::IERC721EnumInit<ContractState> {
        fn initializer(
            ref self: ContractState,
            name: ByteArray,
            symbol: ByteArray,
            base_uri: ByteArray,
            recipient: ContractAddress,
            token_ids: Span<u256>
        ) {
            assert(
                self.world().is_owner(self.selector(), get_caller_address()),
                Errors::CALLER_IS_NOT_OWNER
            );

            self.erc721_metadata.initialize(name, symbol, base_uri);
            self.erc721_enumerable.initialize();

            self.mint_assets(recipient, token_ids);

            self.initializable.initialize();
        }
    }

    #[abi(embed_v0)]
    impl MintBurnImpl of super::IERC721EnumMintBurn<ContractState> {
        fn mint(ref self: ContractState, to: ContractAddress, token_id: u256) {
            self.erc721_mintable.mint(to, token_id);
        }

        fn burn(ref self: ContractState, token_id: u256) {
            self.erc721_burnable.burn(token_id);
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn mint_assets(
            ref self: ContractState, recipient: ContractAddress, mut token_ids: Span<u256>
        ) {
            loop {
                if token_ids.len() == 0 {
                    break;
                }
                let id = *token_ids.pop_front().unwrap();
                
                self.erc721_mintable.mint(recipient, id);
            }
        }
    }
}
